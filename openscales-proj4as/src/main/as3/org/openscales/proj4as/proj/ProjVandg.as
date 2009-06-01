/*******************************************************************************
NAME                    VAN DER GRINTEN 

PURPOSE:	Transforms input Easting and Northing to longitude and
		latitude for the Van der Grinten projection.  The
		Easting and Northing must be in meters.  The longitude
		and latitude values will be returned in radians.

PROGRAMMER              DATE            
----------              ----           
T. Mittan		March, 1993

This function was adapted from the Van Der Grinten projection code
(FORTRAN) in the General Cartographic Transformation Package software
which is available from the U.S. Geological Survey National Mapping Division.
 
ALGORITHM REFERENCES

1.  "New Equal-Area Map Projections for Noncircular Regions", John P. Snyder,
    The American Cartographer, Vol 15, No. 4, October 1988, pp. 341-355.

2.  Snyder, John P., "Map Projections--A Working Manual", U.S. Geological
    Survey Professional Paper 1395 (Supersedes USGS Bulletin 1532), United
    State Government Printing Office, Washington D.C., 1987.

3.  "Software Documentation for GCTP General Cartographic Transformation
    Package", U.S. Geological Survey National Mapping Division, May 1982.
*******************************************************************************/

package org.openscales.proj4as.proj
{
	import org.openscales.proj4as.ProjPoint;
	import org.openscales.proj4as.ProjConstants;
	import org.openscales.proj4as.Datum;
			
	public class ProjVandg extends AbstractProjProjection
	{

		protected var R:Number;			
		
		public function ProjVandg(data:ProjParams)
		{
			super(data);
		}
		
  override public function init():void
  	{
		this.R = 6370997.0; //Radius of earth
	}

  override public function forward(p:ProjPoint):ProjPoint 
  	{
		var lon:Number=p.x;
		var lat:Number=p.y;	

		/* Forward equations
		-----------------*/
		var dlon:Number = ProjConstants.adjust_lon(lon - this.long0);
		var x:Number,y:Number;

		if (Math.abs(lat) <= ProjConstants.EPSLN) {
			x = this.x0  + this.R * dlon;
			y = this.y0;
		}
		var theta:Number = ProjConstants.asinz(2.0 * Math.abs(lat / ProjConstants.PI));
		if ((Math.abs(dlon) <= ProjConstants.EPSLN) || (Math.abs(Math.abs(lat) - ProjConstants.HALF_PI) <= ProjConstants.EPSLN)) {
			x = this.x0;
			if (lat >= 0) {
				y = this.y0 + ProjConstants.PI * this.R * Math.tan(.5 * theta);
			} else {
				y = this.y0 + ProjConstants.PI * this.R * - Math.tan(.5 * theta);
			}
			//  return(OK);
		}
		var al:Number = .5 * Math.abs((ProjConstants.PI / dlon) - (dlon / ProjConstants.PI));
		var asq:Number = al * al;
		var sinth:Number = Math.sin(theta);
		var costh:Number = Math.cos(theta);

		var g :Number= costh / (sinth + costh - 1.0);
		var gsq:Number = g * g;
		var m:Number = g * (2.0 / sinth - 1.0);
		var msq:Number = m * m;
		var con:Number = ProjConstants.PI * this.R * (al * (g - msq) + Math.sqrt(asq * (g - msq) * (g - msq) - (msq + asq) * (gsq - msq))) / (msq + asq);
		if (dlon < 0) {
		 con = -con;
		}
		x = this.x0 + con;
		con = Math.abs(con / (ProjConstants.PI * this.R));
		if (lat >= 0) {
		 y = this.y0 + ProjConstants.PI * this.R * Math.sqrt(1.0 - con * con - 2.0 * al * con);
		} else {
		 y = this.y0 - ProjConstants.PI * this.R * Math.sqrt(1.0 - con * con - 2.0 * al * con);
		}
		p.x = x;
		p.y = y;
		return p;
	}

/* Van Der Grinten inverse equations--mapping x,y to lat/long
  ---------------------------------------------------------*/
   override public function inverse(p:ProjPoint):ProjPoint
   {
		var dlon:Number,lat:Number,lon:Number;
		var xx:Number,yy:Number,xys:Number,c1:Number,c2:Number,c3:Number;
		var al:Number,asq:Number;
		var a1:Number;
		var m1:Number;
		var con:Number;
		var th1:Number;
		var d:Number;

		/* inverse equations
		-----------------*/
		p.x -= this.x0;
		p.y -= this.y0;
		con = ProjConstants.PI * this.R;
		xx = p.x / con;
		yy =p.y / con;
		xys = xx * xx + yy * yy;
		c1 = -Math.abs(yy) * (1.0 + xys);
		c2 = c1 - 2.0 * yy * yy + xx * xx;
		c3 = -2.0 * c1 + 1.0 + 2.0 * yy * yy + xys * xys;
		d = yy * yy / c3 + (2.0 * c2 * c2 * c2 / c3 / c3 / c3 - 9.0 * c1 * c2 / c3 /c3) / 27.0;
		a1 = (c1 - c2 * c2 / 3.0 / c3) / c3;
		m1 = 2.0 * Math.sqrt( -a1 / 3.0);
		con = ((3.0 * d) / a1) / m1;
		if (Math.abs(con) > 1.0) {
			if (con >= 0.0) {
				con = 1.0;
			} else {
				con = -1.0;
			}
		}
		th1 = Math.acos(con) / 3.0;
		if (p.y >= 0) {
			lat = (-m1 *Math.cos(th1 + ProjConstants.PI / 3.0) - c2 / 3.0 / c3) * ProjConstants.PI;
		} else {
			lat = -(-m1 * Math.cos(th1 + Math.PI / 3.0) - c2 / 3.0 / c3) * ProjConstants.PI;
		}

		if (Math.abs(xx) < ProjConstants.EPSLN) {
			lon = this.long0;
		}
		lon = ProjConstants.adjust_lon(this.long0 + ProjConstants.PI * (xys - 1.0 + Math.sqrt(1.0 + 2.0 * (xx * xx - yy * yy) + xys * xys)) / 2.0 / xx);

		p.x=lon;
		p.y=lat;
		return p;
	}
		
		
	}
}
package com.lylib.touch.geom
{
    import flash.geom.*;

    public class Vector2D
    {
        public var y:Number;
        public var x:Number;

        public function Vector2D(x:Number = 0, y:Number = 0)
        {
            this.x = x;
            this.y = y;
        }

        public function cross(v:Vector2D) : Number
        {
            return x * v.y - y * v.x;
        }

        public function dividedBy(scalar:Number) : Vector2D
        {
            return new Vector2D(x / scalar, y / scalar);
        }

        public function times(scalar:Number) : Vector2D
        {
            return new Vector2D(x * scalar, y * scalar);
        }

        public function dot(v:Vector2D) : Number
        {
            return x * v.x + y * v.y;
        }

        public function normalize() : void
        {
            dividedByEquals(magnitude);
        }

        public function minusEquals(v:Vector2D) : void
        {
            x = x - v.x;
            y = y - v.y;
        }

        public function distanceTo(v:Vector2D) : Number
        {
            return Math.sqrt((x - v.x) * (x - v.x) + (y - v.y) + (y - v.y));
        }

        public function get magnitude() : Number
        {
            return Math.sqrt(x * x + y * y);
        }

        public function plus(v:Vector2D) : Vector2D
        {
            return new Vector2D(x + v.x, y + v.y);
        }

        public function clone() : Vector2D
        {
            return new Vector2D(x, y);
        }

        public function dividedByEquals(scalar:Number) : void
        {
            x = x / scalar;
            y = y / scalar;
        }

        public function timesEquals(scalar:Number) : void
        {
            x = x * scalar;
            y = y * scalar;
        }

        public function getPerp() : Vector2D
        {
            return new Vector2D(-y, x);
        }

        public function toString() : String
        {
            return "[" + this.x + "," + this.y + "]";
        }

        public function minus(v:Vector2D) : Vector2D
        {
            return new Vector2D(x - v.x, y - v.y);
        }

        public function plusEquals(v:Vector2D) : void
        {
            x = x + v.x;
            y = y + v.y;
        }

        public function getUnit() : Vector2D
        {
            return dividedBy(magnitude);
        }

        public function asPoint() : Point
        {
            return new Point(x, y);
        }

        public static function angleBetween(v1:Vector2D, v2:Vector2D) : Number
        {
            var _loc_3:Number = NaN;
            v1 = v1.clone();
            v2 = v2.clone();
            v1.normalize();
            v2.normalize();
            _loc_3 = v1.x * v2.x + v1.y * v2.y;
            if (_loc_3 > 1)
            {
                _loc_3 = 1;
            }
            else if (_loc_3 < -1)
            {
                _loc_3 = -1;
            }
            return Math.acos(_loc_3);
        }

    }
}

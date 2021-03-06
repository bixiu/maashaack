﻿/*
  Version: MPL 1.1/GPL 2.0/LGPL 2.1
 
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.
  
  The Original Code is [maashaack framework].
  
  The Initial Developers of the Original Code are
  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.
  Portions created by the Initial Developers are Copyright (C) 2006-2009
  the Initial Developers. All Rights Reserved.
  
  Contributor(s):
  
  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the LGPL or the GPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.
*/

package system.formatters 
{
    import system.Reflection;
    import system.Serializable;
    import system.hack;
    import system.numeric.Range;
    
    /**
     * DateFormatter formats a given date with a specified pattern.
     * <p>Use the declared constants as placeholders for specific parts of the date-time.</p>
     * <p>All characters from 'A' to 'Z' and from 'a' to 'z' are reserved, although not all of these characters are interpreted right now.</p> 
     * <p>If you want to include plain text in the pattern put it into quotes (') to avoid interpretation.</p>
     * <p>If you want a quote in the formatted date-time, put two quotes directly after one another. For example: <code class="prettyprint"> "hh 'o''clock'"}.</p>
     * <pre class="prettyprint">
     * import system.formatter.DateFormatter ;
     * 
     * var f:DateFormatter = new DateFormatter() ;
     * 
     * f.pattern = "yyyy DDDD d MMMM - hh 'h' nn 'mn' ss 's'" ;
     * 
     * var result:String = f.format() ;
     * 
     * trace("pattern : " + f.pattern) ;
     * trace("result  : " + result) ;
     * 
     * trace("----") ;
     * 
     * f.pattern = "DDDD d MMMM yyyy" ;
     * 
     * var result:String = f.format(new Date(2005, 10, 22)) ;
     * 
     * trace("pattern : " + f.pattern) ;
     * trace("result  : " + result) ;
     * 
     * trace("----") ;
     * 
     * f.pattern = "hh 'h' nn 'mn' ss 's' tt" ;
     * trace( f.format( new Date(2008,1,21,10,15,0,0) ) ) ; // 10 h 15 mn 00 s am
     * 
     * f.pattern = "hh 'h' nn 'mn' ss 's' t" ;
     * trace( formatter.format( new Date(2008,1,21,10,15,0,0) ) ) ; // 10 h 15 mn 00 s a
     * 
     * f.pattern = "hh 'h' nn 'mn' ss 's' TT" ; // capitalize the pm expression.
     * trace( formatter.format( new Date(2008,1,21,14,15,0,0) ) ) ; // 02 h 15 mn 00 s PM
     * </pre>
     */
    public class DateFormatter implements Formattable, Serializable 
    {
        use namespace hack;
        
        /**
         * Creates a new DateFormatter instance.
         * <p>If you do not pass-in a pattern or if the passed-in one is null or undefined the constant DEFAULT_DATE_FORMAT is used ("dd.mm.yyyy HH:nn:ss").</p>
         * @param pattern (optional) the pattern describing the date and time format.
         */
        public function DateFormatter( pattern:String = "dd.mm.yyyy HH:nn:ss" )
        {
            _pattern = pattern ;
        }
        
        /**
         * Placeholder for AM/PM designator who indicates if the hour is is before or after noon in date format.
         * The output is lower-case. Examples: t -> a or p  / tt -> am or pm.
         */
        public static const AM_PM:String = "t" ;
        
        /**
         * Placeholder for AM/PM designator who indicates if the hour is is before or after noon in date format.
         * The output is capitalized. Examples: T -> T or P / TT -> AM or PM.
         */
        public static const CAPITAL_AM_PM:String = "T" ;
        
        /**
         * The default AM/PM designator expression.
         */
        public static var DEFAULT_AM_EXPRESSION:String = "am" ;
        
        /**
         * The default date format pattern <code class="prettyprint">"dd.mm.yyyy HH:nn:ss"</code>.
         */
        public static const DEFAULT_DATE_FORMAT:String = "dd.mm.yyyy HH:nn:ss" ;
        
        /**
         * Placeholder for day in month as number in date format.
         */
        public static const DAY_AS_NUMBER:String = "d" ;
        
        /**
         * Placeholder for day in week as text in date format.
         */
        public static const DAY_AS_TEXT:String = "D" ;
        
        /**
         * The default AM/PM designator expression.
         */
        public static  var DEFAULT_PM_EXPRESSION:String = "pm" ;
        
        /**
         * Placeholder for hour in am/pm (1 - 12) in date format.
         */
        public static const HOUR_IN_AM_PM:String = "h" ;
        
        /**
         * Placeholder for hour in day (0 - 23) in date format.
         */
        public static const HOUR_IN_DAY:String = "H" ;
        
        /**
         * Placeholder for minute in hour in date format.
         */
        public static const MINUTE:String = "n" ;
        
        /**
         * Placeholder for millisecond in date format.
         */
        public static const MILLISECOND:String = "S" ;
        
        /**
         * Placeholder for month in year as number in date format.
         */
        public static const MONTH_AS_NUMBER:String = "m" ;
        
        /**
         * Placeholder for month in year as text in date format.
         */
        public static const MONTH_AS_TEXT:String = "M" ;
        
        /**
         * Quotation beginning and ending token. 
         */
        public static const QUOTE:String = "'" ;
        
        /**
         * The internal range use to defined the days as text in the DateFormatter.
         */
        public static const RANGE_DAY_AS_TEXT:Range = new Range( 0 , 6 ) ;
        
        /**
         * The internal range use to defined the hours in the DateFormatter.
         */
        public static const RANGE_HOUR:Range = new Range( 0 , 23 ) ;
        
        /**
         * The internal range use to defined the minutes in the DateFormatter.
         */
        public static const RANGE_MINUTE:Range = new Range( 0 , 59 ) ;
        
        /**
         * The internal range use to defined the milliseconds in the DateFormatter.
         */
        public static const RANGE_MILLISECOND:Range = new Range( 0 , 999 ) ;
        
        /**
         * The internal range use to defined the months in the DateFormatter.
         */
        public static const RANGE_MONTH:Range = new Range( 0 , 11 ) ;
        
        /**
         * The internal range use to defined the seconds in the DateFormatter.
         */
        public static const RANGE_SECOND:Range = new Range( 0 , 59 ) ;
        
        /**
         * Placeholder for second in minute in date format.
         */
        public static const SECOND:String = "s" ;
        
        /**
         * Placeholder for year in date format.
         */
        public static const YEAR:String = "y" ;
        
        /**
         * Indicates the internal pattern of this formatter.
         */
        public function get pattern():String 
        {
            return _pattern ;
        }
        
        /**
         * @private
         */
        public function set pattern( expression:String ):void 
        {
            this._pattern = expression ;
        }
        
        /**
         * Creates and returns a shallow copy of the object.
         * @return A new object that is a shallow copy of this instance.
         */ 
        public function clone():*
        {
            return new DateFormatter( pattern ) ;
        }
        
        /**
         * Formats the specified value.
         * <pre class="prettyprint">
         * import system.formatter.DateFormatter ;
         * 
         * var f:DateFormatter = new DateFormatter() ;
         * 
         * f.pattern = "yyyy DDDD d MMMM - hh 'h' nn 'mn' ss 's'" ;
         * var result:String = f.format() ;
         * trace("pattern : " + f.pattern) ;
         * trace("result  : " + result) ;
         * 
         * trace("----") ;
         *
         * f.pattern = "DDDD d MMMM yyyy" ;
         * var result:String = f.format(new Date(2005, 10, 22)) ;
         * trace("pattern : " + f.pattern) ;
         * trace("result  : " + result) ;
         * 
         * trace("----") ;
         * 
         * f.pattern = "hh 'h' nn 'mn' ss 's' tt" ;
         * trace( f.format( new Date(2008,1,21,10,15,0,0) ) ) ; // 02 h 15 mn 00 s am
         * 
         * f.pattern = "hh 'h' nn 'mn' ss 's' t" ;
         * trace( formatter.format( new Date(2008,1,21,10,15,0,0) ) ) ; // 02 h 15 mn 00 s a
         * 
         * f.pattern = "hh 'h' nn 'mn' ss 's' TT" ; // capitalize the pm expression.
         * trace( formatter.format( new Date(2008,1,21,14,15,0,0) ) ) ; // 02 h 15 mn 00 s PM
         * </pre>
         * @param value The object to format.
         * @return the string representation of the formatted value. 
         */
        public function format( value:* = null ):String
        {
            if (pattern == null) 
            {
                return "" ;
            }
            
            var cpt:int ;
            var ch:String ;
             
            // current character
            
            var date:Date = ( value != null && value is Date) ? (value as Date) : new Date() ;
            
            var next:int ;
            var prev:int ;
            
            var p:String = pattern ;
            var a:Array  = p.split( "" ) ;
            var l:int    = a.length ;
            var i:int    = - 1 ;
            var r:String = "" ;
            
            while (++ i < l) 
            {
                ch = a[i] ;
                if ( ch == DateFormatter.QUOTE ) 
                {
                    if (a[i + 1] == DateFormatter.QUOTE) 
                    {
                        r += "'" ; 
                        i++ ;
                    }
                    next = i ;
                    while ( true ) 
                    {
                        prev = next ;
                        next = p.indexOf( "'", next + 1 ) ;
                        if (a[next + 1] != QUOTE) break ;
                        r += p.substring( prev + 1, next + 1 ) ;
                        next++;
                    }
                    r += p.substring( prev + 1, next ) ;
                    i = next ;
                } 
                else if ( ch == YEAR ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatYear( date.getFullYear( ), cpt );
                    i += cpt - 1 ;
                }
                else if ( ch == MONTH_AS_NUMBER ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatMonthAsNumber( date.getMonth( ), cpt );
                    i += cpt - 1 ;
                }
                else if ( ch == MONTH_AS_TEXT ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatMonthAsText( date.getMonth( ), cpt ) ;
                    i += cpt - 1 ;
                } 
                else if ( ch == DAY_AS_NUMBER ) 
                {
                    cpt = count( ch, a.slice( i ) ) ;
                    r += formatDayAsNumber( date.getDate( ), cpt ) ;
                    i += cpt - 1 ;
                }
                else if ( ch == DAY_AS_TEXT ) 
                {
                    cpt = count( ch, a.slice( i ) ) ;
                    r += formatDayAsText( date.getDay( ), cpt ) ;
                    i += cpt - 1 ;
                } 
                else if ( ch == HOUR_IN_AM_PM ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatHourInAmPm( date.getHours( ), cpt ) ;
                    i += cpt - 1 ;
                } 
                else if ( ch == HOUR_IN_DAY ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatHourInDay( date.getHours( ), cpt ) ;
                    i += cpt - 1 ;
                } 
                else if ( ch == MINUTE ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatMinute( date.getMinutes( ), cpt ) ;
                    i += cpt - 1 ;
                }
                else if ( ch == SECOND ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatSecond( date.getSeconds( ), cpt ) ;
                    i += cpt - 1 ;
                }
                else if ( ch == MILLISECOND ) 
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatMillisecond( date.getMilliseconds( ), cpt );
                    i += cpt - 1 ;
                }
                else if ( ch == AM_PM || ch == CAPITAL_AM_PM )
                {
                    cpt = count( ch, a.slice( i ) );
                    r += formatDesignator( date.getHours( ), cpt, ch == CAPITAL_AM_PM );
                    i += cpt - 1 ;
                }
                else 
                {
                    r += ch;
                }
            } 
            return r ;
        }
        
        /**
         * Retrieves a list of localized strings containing the month names for the current calendar system.
         */
        public function getMonthNames():Array
        {
            return Months.getMonthNames() ;
        }
        
        /**
         * Retrieves a list of localized strings containing the names of weekdays for the current calendar system.
         */
        public function getWeekdayNames():Array
        {
            return Weekdays.getWeekdayNames() ;
        }
        
        /**
         * Sets a list of localized strings containing the month names for the current calendar system.
         * If you passed-in a null value in the argument of the method, the week days use the default english names.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.formatters.DateFormatter ;
         * var formatter:DateFormatter = new DateFormatter() ;
         * // localize with FR month names
         * formatter.setMonthNames( ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"] ) ;
         * </pre>
         */
        public function setMonthNames( names:Array ):void
        {
            Months.setMonthNames( names ) ;
        }
        
        /**
         * Sets a list of localized strings containing the month names for the current calendar system. 
         * If you passed-in a null value in the argument of the method, the week days use the default english names.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.formatters.DateFormatter ;
         * var formatter:DateFormatter = new DateFormatter() ;
         * // localize with FR month names
         * formatter.setWeekdayNames( ["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"]) ;
         * </pre>
         */
        public function setWeekdayNames( names:Array ):void
        {
            Weekdays.setWeekdayNames( names ) ;
        }
        
        /**
         * Returns the source code string representation of the object.
         * @return the source code string representation of the object.
         */
        public function toSource( indent:int = 0 ):String 
        {
            return "new " + Reflection.getClassPath( this ) + '("' + ( pattern || DEFAULT_DATE_FORMAT ) + '")' ;
        }
        
        /**
         * Formats the specified number day value in a string representation.
         * @return the specified numberday value in a string representation.
         */
        hack function formatDayAsNumber(day:Number, cpt:Number = NaN):String 
        {
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var string:String = day.toString( );
            return (getZeros( cpt - string.length ) + string);
        }
        
        /**
         * Formats the specified day value in a string representation.
         * @return the specified day value in a string representation.
         */
        hack function formatDayAsText(day:Number, cpt:Number = NaN):String 
        {
            if (RANGE_DAY_AS_TEXT.isOutOfRange( day )) 
            {
                throw new Error( this + " formatDayAsText method failed, the day value is out of range." ) ;
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var days:Array = Weekdays.getWeekdayNames( ) ;
            var r:String   = days[day] ;
            if (cpt < 4) 
            {
                return r.substr( 0 , 2 );
            }
            return r ;
        }
        
        /**
         * Formats the designator AM/PM in string expression.
         * @return the specified am/pm expression representation.
         */
        hack function formatDesignator(hour:Number, cpt:Number, capitalize:Boolean ):String 
        {
            if ( RANGE_HOUR.isOutOfRange( hour ) )
            {
                throw new Error( this + " formatDesignator method failed, the hour value is out of range." ) ;
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var s:String = ( hour > 12 ) ? DEFAULT_PM_EXPRESSION : DEFAULT_AM_EXPRESSION ;
            s = s.slice( 0 , cpt ) ;
            return capitalize ? s.toUpperCase() : s.toLowerCase() ;
        }
        
        /**
         * Formats the specified hour value in a string representation with the am-pm notation.
         * @return the specified hour value in a string representation with the am-pm notation.
         */
        hack function formatHourInAmPm(hour:Number, cpt:Number = NaN):String 
        {
            if ( RANGE_HOUR.isOutOfRange( hour ) ) 
            {
                throw new Error( this + " formatHourInAmPm method failed, the hour value is out of range." ) ;
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var s:String ;
            if (hour == 0) 
            {
                s = (12).toString( ) ;
            }
            else if (hour > 12) 
            {
                s = (hour - 12).toString( ) ;
            }
            else 
            {
                s = hour.toString( );
            }
            return (getZeros( cpt - s.length ) + s);
        }
        
        /**
         * Formats an hour number in string expression.
         */
        hack function formatHourInDay(hour:Number, cpt:Number = NaN):String 
        {
            if ( RANGE_HOUR.isOutOfRange( hour ) )
            {
                throw new Error( this + " formatHourInDay method failed, the hour value is out of range." ) ;
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var s:String = hour.toString( );
            return (getZeros( cpt - s.length ) + s) ;
        }
        
        /**
         * Formats a millisecond value number in string expression.
         */
        hack function formatMillisecond(millisecond:Number, cpt:Number = NaN):String 
        {
            if (RANGE_MILLISECOND.isOutOfRange( millisecond ) ) 
            {
                throw new Error( this + " formatMillisecond method failed, the millisecond value is out of range." );
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var s:String = millisecond.toString();
            return (getZeros( cpt - s.length ) + s) ;
        }
        
        /**
         * Formats a minute value number in string expression.
         */
        hack function formatMinute(minute:Number, cpt:Number = NaN):String 
        {
            if (RANGE_MINUTE.isOutOfRange( minute )) 
            {
                throw new Error( this + " formatMinute method failed, the minute value is out of range." ) ;
            }
            if ( isNaN( cpt ) ) 
            {
                cpt = 0 ;
            }
            var s:String = minute.toString( );
            return (getZeros( cpt - s.length ) + s);
        }
        
        /**
         * Formats a month value number in string expression.
         */
        hack function formatMonthAsNumber( month:Number, cpt:Number = NaN ):String 
        {
            if (RANGE_MONTH.isOutOfRange( month )) 
            {
                throw new Error( this + " formatMonthAsNumber method failed, the month value is out of range." ) ;
            }
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            var string:String = (month + 1).toString( );
            return (getZeros( cpt - string.length ) + string) ;
        }
        
        /**
         * Formats a month text value in string expression.
         */
        hack function formatMonthAsText(month:Number, cpt:Number = NaN):String 
        {
            if (RANGE_MONTH.isOutOfRange( month )) 
            {
                throw new Error( this + " formatMonthAsText method failed, the month value is out of range." ) ;
            }
            if (isNaN( cpt )) cpt = 0 ;
            var r:String;
            var months:Array = Months.getMonthNames() ;
            r = months[month] ;
            if (cpt < 4) 
            { 
                return r.substr( 0, 3 );
            }
            return r;
        }
        
        /**
         * Format the second value passed in argument.
         * @return the second string representation of this DateFormatter.
         */
        hack function formatSecond(second:Number, cpt:Number = NaN):String 
        {
            if (RANGE_SECOND.isOutOfRange( second )) 
            {
                throw new Error( this + " formatSecond method failed, the second value is out of range." ) ;
            }
            if (isNaN( cpt ))
            {
                cpt = 0 ;
            }
            var s:String = second.toString() ;
            return (getZeros( cpt - s.length ) + s);
        }
        
        /**
         * Format the year value passed in argument.
         * @return the year string representation of this DateFormatter.
         */
        hack function formatYear( year:Number = NaN , cpt:Number = NaN ):String 
        {
            if ( isNaN( year ) ) 
            {
                throw new Error( this + " formatYear method failed, the year value must be a Number." ) ;
            }    
            if (isNaN( cpt )) 
            {
                cpt = 0 ;
            }
            if (cpt < 4) 
            {
                return year.toString().substr( 2 ) ;
            }
            return (getZeros( cpt - 4 ) + year.toString( ));
        }
        
        /**
         * Returns a string representation fill by 0 values or an empty string if the cpt value is NaN or <1.
         * @return a string representation fill by 0 values or an empty string if the cpt value is NaN or <1.
         */
        hack function getZeros(cpt:Number):String 
        {
            if (cpt < 1 || isNaN( cpt )) 
            {
                return "" ;
            }
            if (cpt < 2) 
            {
                return "0" ;
            }    
            var r:String = "00";
            cpt -= 2;
            while (cpt) 
            {
                r += "0" ;
                cpt-- ;
            }
            return r ;
        }
        
        /**
         * The internal pattern of this formatter.
         */
        hack var _pattern:String ; 
        
        // pattern
         
        /**
         * @private
         */
        hack function count(char:String, a:Array):Number 
        {
            if (! a) 
            {
                return 0 ;
            }
            var r:int = 0 ;
            var i:int = - 1 ;
            var l:int = a.length ;
            while (++ i < l && a[r] == char) 
            {
                r++ ;
            }
            return r ;
        }
    }
}

/**
 * This static enumeration class register all string constants to defined a month.
 */
class Months
{
    /**
     * Fully written out string for january.
     */
    public static const JANUARY:String = "January" ;
    
    /**
     * Fully written out string for february.
     */
    public static const FEBRUARY:String = "February" ;
    
    /**
     * Fully written out string for march.
     */
    public static const MARCH:String = "March" ;
    
    /**
     * Fully written out string for april.
     */
    public static const APRIL:String = "April" ;
    
    /**
     * Fully written out string for may.
     */
    public static const MAY:String = "May" ;
    
    /**
     * Fully written out string for june.
     */
    public static const JUNE:String = "June" ;
    
    /**
     * Fully written out string for july.
     */
    public static const JULY:String = "July" ;
    
    /**
     * Fully written out string for august.
     */
    public static const AUGUST:String = "August" ;
    
    /**
     * Fully written out string for september.
     */
    public static const SEPTEMBER:String = "September" ;
    
    /**
     * Fully written out string for october.
     */
    public static const OCTOBER:String = "October" ;
    
    /**
     * Fully written out string for november.
     */
    public static const NOVEMBER:String = "November" ;
    
    /**
     * Fully written out string for december.
     */
    public static const DECEMBER:String = "December" ;
    
    /**
     * Retrieves a list of localized strings containing the month names for the current calendar system.
     * @return a list of localized strings containing the month names for the current calendar system.
     */
    public static function getMonthNames():Array 
    {
        return _names ;
    }
    
    /**
     * Sets a list of localized strings containing the month names for the current calendar system.
     */
    public static function setMonthNames( names:Array ):void
    {
        _names = [ JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER ] ;
        if ( names != null && names.length > 0 )
        {
            _names[ 0] = names[ 0] is String ? names[ 0] : JANUARY ;
            _names[ 1] = names[ 1] is String ? names[ 1] : FEBRUARY ;
            _names[ 2] = names[ 2] is String ? names[ 2] : MARCH ;
            _names[ 3] = names[ 3] is String ? names[ 3] : APRIL ;
            _names[ 4] = names[ 4] is String ? names[ 4] : MAY ;
            _names[ 5] = names[ 5] is String ? names[ 5] : JUNE ;
            _names[ 6] = names[ 6] is String ? names[ 6] : JULY ;
            _names[ 7] = names[ 7] is String ? names[ 7] : AUGUST ;
            _names[ 8] = names[ 8] is String ? names[ 8] : SEPTEMBER ;
            _names[ 9] = names[ 9] is String ? names[ 9] : OCTOBER ;
            _names[10] = names[10] is String ? names[10] : NOVEMBER ;
            _names[11] = names[11] is String ? names[11] : DECEMBER ;
        }
    }
    
    /**
     * @private
     */
    private static var _names:Array = [ JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER ] ;
}

/**
 * This static enumeration class register all string constants to defined a day.
 */
class Weekdays
{
    /**
     * Fully written out string for monday.
     */
    public static const MONDAY:String = "Monday" ;
    
    /**
     * Fully written out string for tuesday.
     */
    public static const TUESDAY:String = "Tuesday" ;
    
    /**
     * Fully written out string for wednesday.
     */
    public static const WEDNESDAY:String = "Wednesday" ;
    
    /**
     * Fully written out string for thursday.
     */
    public static const THURSDAY:String = "Thursday" ;
    
    /**
     * Fully written out string for friday.
     */
    public static const FRIDAY:String = "Friday" ;
    
    /**
     * Fully written out string for saturday.
     */
    public static const SATURDAY:String = "Saturday" ;
    
    /**
     * Fully written out string for sunday.
     */
    public static const SUNDAY:String = "Sunday" ;
    
    /**
     * Retrieves a list of localized strings containing the names of weekdays for the current calendar system.
     */
    public static function getWeekdayNames():Array 
    {
        return _names ;
    }
    
    /**
     * Sets a list of localized strings containing the week days names for the current calendar system.
     */
    public static function setWeekdayNames( names:Array ):void
    {
        _names = [ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY ] ;
        if ( names != null && names.length > 0 )
        {
            _names[ 0] = names[ 0] is String ? names[ 0] : SUNDAY ;
            _names[ 1] = names[ 1] is String ? names[ 1] : MONDAY ;
            _names[ 2] = names[ 2] is String ? names[ 2] : TUESDAY ;
            _names[ 3] = names[ 3] is String ? names[ 3] : WEDNESDAY ;
            _names[ 4] = names[ 4] is String ? names[ 4] : THURSDAY ;
            _names[ 5] = names[ 5] is String ? names[ 5] : FRIDAY ;
            _names[ 6] = names[ 6] is String ? names[ 6] : SATURDAY ;
        }
    }
    
    /**
     * @private
     */
    private static var _names:Array = [ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY ] ;
}

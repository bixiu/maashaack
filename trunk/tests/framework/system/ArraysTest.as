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
  Portions created by the Initial Developers are Copyright (C) 2006-2010
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

package system
{
    import buRRRn.ASTUce.framework.ArrayAssert;
    import buRRRn.ASTUce.framework.TestCase;
    
    public class ArraysTest extends TestCase
    {
        public function ArraysTest( name:String = "" )
        {
            super(name);
        }
        
        public function testContains():void
        {
            var ar:Array =  [2, 3, 4] ;
            assertTrue( Arrays.contains( ar , 3 ) as Boolean ) ;
            assertFalse( Arrays.contains( ar , 5 ) as Boolean ) ;
        }
        
//        TAMARIN::exclude
        public function testCopyPrimitive():void
        {
            var a:Array = [ 0, 1, true, false ];
            
            var copy:Array = Arrays.copy( a );
            
            assertNotSame( a, copy );
            assertTrue( copy is Array );
            ArrayAssert.assertEquals( a, copy );
        }
        
        public function testShallowCopy():void
        {
            var a:Array = [ 0, 1, true, false ];
            
            var copy:Array = Arrays.copy( a, true );
            
            assertNotSame( a, copy );
            assertTrue( copy is Array );
            ArrayAssert.assertEquals( a, copy );
        }
        
//        TAMARIN::exclude
        public function testCopySpecialValues():void
        {
            var a:Array = [ undefined, null ];
            
            var copy1:Array = Arrays.copy( a );
            var copy2:Array = Arrays.copy( a, true );
            
            assertUndefined( copy1[0] );
            assertNull( copy1[1] );
            ArrayAssert.assertEquals( a, copy1 );
            
            assertUndefined( copy2[0] );
            assertNull( copy2[1] );
            ArrayAssert.assertEquals( a, copy2 );
        }
        
        public function testInitialize():void
        {
            ArrayAssert.assertEquals( [] , Arrays.initialize() ) ;
            ArrayAssert.assertEquals( [ null , null , null ] , Arrays.initialize(3) ) ;
            ArrayAssert.assertEquals( [ 0    , 0    , 0    ] , Arrays.initialize(3,0) ) ;
            ArrayAssert.assertEquals( [ true , true , true ] , Arrays.initialize(3,true) ) ;
            ArrayAssert.assertEquals( [ ""   , ""   , ""  , ""  ] , Arrays.initialize(4,"") ) ;
        }
        
        public function testRepeat():void
        {
            var ar:Array =  [2, 3, 4] ;
            ArrayAssert.assertEquals( [2, 3, 4] , Arrays.repeat(ar, 0) ) ;
            ArrayAssert.assertEquals( [2,3,4,2,3,4,2,3,4] , Arrays.repeat(ar, 3) ) ; 
        }
        
        public function testReduce1():void
        {
            var ar:Array =  [0,1,2,3,4] ;
            var callback:Function = function( previousValue:* , currentValue:* , index:int, array:Array ):*
            {
                // trace( "previousValue = " + previousValue + ", currentValue = " + currentValue + ", index = " + index ) ;
                return previousValue + currentValue ;
            } ;
            assertEquals( 10 , Arrays.reduce( ar , callback )      , "#1" ) ;
            assertEquals( 20 , Arrays.reduce( ar , callback , 10 ) , "#2" ) ;
        }
        
        public function testReduce2():void
        {
            var ar:Array =  [[0,1], [2,3], [4,5]] ;
            var callback:Function = function( previousValue:* , currentValue:* , index:int, array:Array ):*
            {
                return previousValue.concat( currentValue ) ;
            } ;
            ArrayAssert.assertEquals( [0, 1, 2, 3, 4, 5] , Arrays.reduce( ar , callback , [] ) ) ;
        }
        
        public function testReduceRight1():void
        {
            var ar:Array =  [0,1,2,3,4] ;
            var callback:Function = function( previousValue:* , currentValue:* , index:int, array:Array ):*
            {
                // trace( "previousValue = " + previousValue + ", currentValue = " + currentValue + ", index = " + index ) ;
                return previousValue + currentValue ;
            } ;
            assertEquals( 10 , Arrays.reduceRight( ar , callback )      , "#1" ) ;
            assertEquals( 20 , Arrays.reduceRight( ar , callback , 10 ) , "#2" ) ;
        }
        
        public function testReduceRight2():void
        {
            var ar:Array =  [[0,1], [2,3], [4,5]] ;
            var callback:Function = function( previousValue:* , currentValue:* , index:int, array:Array ):*
            {
                return previousValue.concat( currentValue ) ;
            } ;
            ArrayAssert.assertEquals( [4,5,2,3,0,1] , Arrays.reduceRight( ar , callback , [] ) ) ;
        }
        
        public function testSpliceInto():void
        {
            var inserted:Array  ;
            var container:Array ;
            
            inserted  = [1, 2, 3, 4] ;
            container = [5, 6, 7, 8] ;
            
            Arrays.spliceInto( inserted, container ) ;
            ArrayAssert.assertEquals( [1,2,3,4,5,6,7,8] , container ) ; 
            
            //////
            
            inserted  = [1, 2, 3, 4] ;
            container = [5, 6, 7, 8] ;
            
            Arrays.spliceInto( inserted, container, 0 , 4 ) ;
            ArrayAssert.assertEquals( [1,2,3,4] , container ) ; 
            
            //////
            
            inserted  = [1, 2, 3, 4] ;
            container = [5, 6, 7, 8] ;
            
            Arrays.spliceInto( inserted, container, 0 , 2 ) ;
            ArrayAssert.assertEquals( [1,2,3,4,7,8] , container ) ; 
            
            //////
            
            inserted  = [1, 2, 3, 4] ;
            container = [5, 6, 7, 8] ;
            
            Arrays.spliceInto( inserted, container, 1 ) ;
            ArrayAssert.assertEquals( [5,1,2,3,4,6,7,8] , container ) ;
            
            //////
            
            inserted  = [1, 2, 3, 4] ;
            container = [5, 6, 7, 8] ;
            
            Arrays.spliceInto( inserted, container, 1 , 2 ) ;
            ArrayAssert.assertEquals( [5,1,2,3,4,8] , container ) ; 
        }
    }
}
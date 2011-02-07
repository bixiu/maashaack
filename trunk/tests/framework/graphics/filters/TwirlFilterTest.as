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
package graphics.filters 
{
    import buRRRn.ASTUce.framework.TestCase;

    import flash.display.Shader;
    import flash.geom.Point;

    public class TwirlFilterTest extends TestCase 
    {
        public function TwirlFilterTest( name:String = "" )
        {
            super(name);
        }
        
        public var filter:TwirlFilter ;
        public var shader:Shader ;
        
        public function setUp():void
        {
            shader = new Shader( new Twirl() ) ;
            filter = new TwirlFilter
            ( 
                shader , 
                { 
                    angle    : 100 , 
                    center   : new Point(10,20) , 
                    gaussian : true , 
                    radius   : 1 
                } 
            ) ;
        }
        
        public function tearDown():void
        {
            shader = null ;
            filter = null ;
        }
        
        public function testConstructor():void
        {
            assertNotNull( filter ) ;
            assertEquals( filter.angle , 100 ) ; 
            assertEquals( filter.center.x , 10 ) ; 
            assertEquals( filter.center.y , 20 ) ; 
            assertTrue( filter.gaussian ) ; 
            assertEquals( filter.radius , 1 ) ; 
        }
        
        public function testDescription():void
        {
            assertEquals( "Twist a bitmap picture." , filter.description ) ;
        }
        
        public function testName():void
        {
            assertEquals( "Twirl" , filter.name ) ; 
        }
        
        public function testNamespace():void
        {
            assertEquals( "graphics.filters" , filter.namespace ) ;
        }
        
        public function testVersion():void
        {
            assertEquals( filter.version , 1 ) ; 
        }
        
        public function testClone():void
        {
            var clone:TwirlFilter = filter.clone() as TwirlFilter ;
            assertNotNull( clone ) ;
            assertEquals( clone.shader , filter.shader ) ;
        }
    }
}
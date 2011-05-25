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
  Portions created by the Initial Developers are Copyright (C) 2006-2011
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
package system.rules 
{
    import buRRRn.ASTUce.framework.TestCase;

    public class EqualsTest extends TestCase 
    {
        public function EqualsTest(name:String = "")
        {
            super( name );
        }
        
        public function test1():void
        {
            var e:Equals ;
            
            e = new Equals( 1 , 1 ) ;
            assertTrue( e.eval() , "#1" ) ;
            
            e = new Equals( 1 , 2 ) ;
            assertFalse( e.eval() , "#2" ) ;
        }
        
        public function test2():void
        {
            var e:Equals ;
            
            var cond1:Condition = new Eval( true  ) ;
            var cond2:Condition = new Eval( false ) ;
            var cond3:Condition = new Eval( true  ) ;
            
            e = new Equals( cond1 , cond1 ) ;
            assertTrue( e.eval() , "#1" ) ;
            
            e = new Equals( cond1 , cond2 ) ;
            assertFalse( e.eval() , "#2" ) ;
            
            e = new Equals( cond1 , cond3 ) ;
            assertTrue( e.eval() , "#3"  ) ;
        }
        
        public function test3():void
        {
            var e:Equals ;
            
            var equals:Function = function( o:Object ):Boolean
            {
                return this.id == o.id ;
            };
            
            var o1:Object = { id:1 , equals:equals } ;
            var o2:Object = { id:2 , equals:equals } ;
            var o3:Object = { id:1 , equals:equals } ;
            
            e = new Equals( o1 , o1 ) ;
            assertTrue( e.eval() , "#1" ) ;
            
            e = new Equals( o1 , o2 ) ;
            assertFalse( e.eval() , "#2" ) ;
            
            e = new Equals( o1 , o3 ) ;
            assertTrue( e.eval() , "#3" ) ;
        }
    }
}
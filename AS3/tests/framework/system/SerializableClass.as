﻿
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is [MaasHaack framework]
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2006-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
*/

package system
{
    import system.eden;
    
    import system.Serializable;
    import system.Strings;    

    public class SerializableClass implements Serializable
        {
        public var a:String;
        public var b:String;
        
        public function SerializableClass( a:String, b:String )
            {
            this.a = a;
            this.b = b;
            }
        
        public function toSource( indent:int = 0 ):String
            {
            var mask:String = "new Serializable( {a}, {b} );";
            var str:String  = Strings.format( mask, {a:eden.serialize( a ), b:eden.serialize( b )} );
            return str;
            }
        
        }
    
    }
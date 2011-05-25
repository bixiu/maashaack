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
package graphics.process.display 
{
    import system.process.Task;
    
    import flash.display.DisplayObjectContainer;
    
    /**
     * This process remove all children in a specific DisplayObjectContainer object.
     */
    public class RemoveChildren extends Task 
    {
        /**
         * Creates a new RemoveChildren instance.
         * @param container The DisplayObjectContainer reference.
         */
        public function RemoveChildren( container:DisplayObjectContainer = null )
        {
            this.container = container ;
        }
        
        /**
         * The DisplayObjectContainer reference.
         */
        public var container:DisplayObjectContainer ;
        
        /**
         * The filters Array representation to apply.
         */
        public var filters:Array ;
        
        /**
         * Returns a shallow copy of this object.
         * @return a shallow copy of this object.
         */
        public override function clone():*
        {
            return new RemoveChildren( container ) ;
        }
        
        /**
         * Run the process.
         */
        public override function run( ...arguments:Array ):void 
        {
            notifyStarted() ;
            try
            {
                if ( container.numChildren > 0 )
                {
                    var size:int = container.numChildren ;
                    while(--size > -1)
                    {
                        container.removeChildAt( size ) ; 
                    }
                }
            }
            catch( e:Error )
            {
                logger.warn(this + " run failed with the display container '" + container + "', error:" + e.toString() ) ;
            }
            notifyFinished() ;
        }
    }
}
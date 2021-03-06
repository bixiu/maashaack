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

package system.process
{
    import system.events.ActionEvent;
    
    /**
     * Dispatched when a process is changed.
     * @eventType system.events.ActionEvent.CHANGE
     * @see #notifyChanged
     */
    [Event(name="change", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is cleared.
     * @eventType system.events.ActionEvent.CLEAR
     * @see #notifyCleared
     */
    [Event(name="clear", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when an info process is running.
     * @eventType system.events.ActionEvent.INFO
     * @see #notifyInfo
     */
    [Event(name="info", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is looped.
     * @eventType system.events.ActionEvent.LOOP
     * @see #notifyLooped
     */
    [Event(name="loop", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is paused.
     * @eventType system.events.ActionEvent.PAUSE
     * @see #notifyPaused
     */
    [Event(name="pause", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is in progress.
     * @eventType system.events.ActionEvent.PROGRESS
     * @see #notifyProgress
     */
    [Event(name="progress", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is resumed.
     * @eventType system.events.ActionEvent.RESUME
     * @see #notifyResumed
     */
    [Event(name="resume", type="system.events.ActionEvent")] 
        
    /**
     * Dispatched when a process is stopped.
     * @eventType system.events.ActionEvent.STOP
     * @see #notifyStopped
     */
    [Event(name="stop", type="system.events.ActionEvent")]
    
    /**
     * Dispatched when a process is out of time.
     * @eventType system.events.ActionEvent.TIMEOUT
     * @see #notifyTimeOut
     */
    [Event(name="timeout", type="system.events.ActionEvent")]
    
    /**
     * This class simplify a full implementation of the <code class="prettyprint">Action</code> interface.
     */
    public dynamic class CoreAction extends Task
    {
        /**
         * Creates a new CoreAction instance.
         * @param global the flag to use a global event flow or a local event flow.
         * @param channel the name of the global event flow if the <code class="prettyprint">global</code> argument is <code class="prettyprint">true</code>.
         */
        public function CoreAction( global:Boolean = false , channel:String = null )
        {
            super( global, channel ) ;
        }
        
        /**
         * The flag to determinate if the Action object is looped.
         */
        public var looping:Boolean ;
        
        /**
         * Returns a shallow copy of this object.
         * @return a shallow copy of this object.
         */
        public override function clone():*
        {
            return new CoreAction( _isGlobal , channel ) ;
        }
        
        /**
         * Notify an ActionEvent when the process is changed.
         */
        protected function notifyChanged():void 
        {
            if ( hasEventListener(_sTypeChange) )
            {
                dispatchEvent( new ActionEvent( _sTypeChange , this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is cleared.
         */
        protected function notifyCleared():void 
        {
            if ( hasEventListener(_sTypeClear) )
            {
                dispatchEvent( new ActionEvent( _sTypeClear , this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process info is changed.
         */
        protected function notifyInfo( info:* ):void
        {
            if ( hasEventListener(_sTypeInfo) )
            {
                dispatchEvent( new ActionEvent( _sTypeInfo, this , info ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is looped.
         */
        protected function notifyLooped():void 
        {
            if ( hasEventListener(_sTypeLoop) )
            {
                dispatchEvent( new ActionEvent( _sTypeLoop, this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is in progress.
         */
        protected function notifyProgress():void
        {
            if ( hasEventListener( _sTypeProgress ) )
            {
                dispatchEvent( new ActionEvent( _sTypeProgress, this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is resumed.
         */
        protected function notifyResumed():void
        {
            if ( hasEventListener( _sTypeResume ) )
            {
                dispatchEvent( new ActionEvent( _sTypeResume , this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is stopped.
         */
        protected function notifyStopped():void
        {
            setRunning(false) ;
            if ( hasEventListener( _sTypeStop ) )
            {
                dispatchEvent( new ActionEvent( _sTypeStop , this ) ) ;
            }
        }
        
        /**
         * Notify an ActionEvent when the process is out of time.
         */
        protected function notifyTimeOut():void
        {
            if ( hasEventListener( _sTypeTimeout ) )
            {
                dispatchEvent( new ActionEvent( _sTypeTimeout , this ) ) ;
            }
        }
        
        /**
         * @private
         */
        protected var _sTypeChange:String = ActionEvent.CHANGE ;
        
        /**
         * @private
         */
        protected var _sTypeClear:String = ActionEvent.CLEAR ;
        
        /**
         * @private
         */
        protected var _sTypeInfo:String  = ActionEvent.INFO ;
        
        /**
         * @private
         */
        protected var _sTypeLoop:String = ActionEvent.LOOP ;
        
        /**
         * @private
         */
        protected var _sTypeProgress:String = ActionEvent.PROGRESS ;
        
        /**
         * @private
         */
        protected var _sTypeResume:String = ActionEvent.RESUME ;
        
        /**
         * @private
         */
        protected var _sTypeStop:String = ActionEvent.STOP ;
        
        /**
         * @private
         */
        protected var _sTypeTimeout:String = ActionEvent.TIMEOUT ;
    }
}
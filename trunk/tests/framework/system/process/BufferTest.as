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

package system.process 
{
    import buRRRn.ASTUce.framework.TestCase;

    import system.events.ActionEvent;
    import system.process.mocks.MockTask;
    import system.process.mocks.MockTaskListener;

    public class BufferTest extends TestCase 
    {
        public function BufferTest(name:String = "")
        {
            super(name);
        }
        
        public var buffer:Buffer ;
        
        public var mockListener:MockTaskListener ;
        
        public function setUp():void
        {
            buffer = new Buffer() ;
            
            buffer.addAction(new MockTask()) ;
            buffer.addAction(new MockTask()) ;
            buffer.addAction(new MockTask()) ;
            buffer.addAction(new MockTask()) ;
        }
        
        public function tearDown():void
        {
            buffer = undefined ; 
            MockTask.reset() ; 
        }
        
        
        public function testInherit():void
        {
            assertTrue( buffer is CoreAction , "inherit Action failed.");
        }
        
        public function testInterface():void
        {
            assertTrue( buffer is Resumable , "Must implements the Resumable interface.");
            assertTrue( buffer is Startable , "Must implements the Startable interface.");
            assertTrue( buffer is Stoppable , "Must implements the Stoppable interface.");
        }
        
        public function testAddAction():void
        {
            var b:Buffer = new Buffer() ;
            assertFalse( b.addAction( null ) ) ;
            assertTrue( b.addAction( new MockTask() ) ) ;
        }
        
        public function testEvents():void
        {
            var b:Buffer = new Buffer() ;
            mockListener = new MockTaskListener(b) ;
            
            b.addAction( new MockTask("testEvents_1") ) ;
            b.addAction( new MockTask("testEvents_2") ) ;
            b.addAction( new MockTask("testEvents_3") ) ;
            b.addAction( new MockTask("testEvents_4") ) ;
            
            b.run() ;
            
            assertTrue( mockListener.isRunning , "The MockSimpleActionListener.isRunning property failed, must be true." ) ;
            assertFalse( b.running , "The running property of the Sequencer must be false after the process." ) ;
            
            assertTrue   ( mockListener.startCalled  , "run method failed, the ActionEvent.START event isn't notify" ) ;
            assertEquals ( mockListener.startType  , ActionEvent.START   , "run method failed, bad type found when the process is started." );
            assertTrue   ( mockListener.finishCalled  , "run method failed, the ActionEvent.START event isn't notify" ) ;
            assertEquals ( mockListener.finishType , ActionEvent.FINISH  , "run method failed, bad type found when the process is finished." );
            
            mockListener.unregister() ;
            mockListener = null ;
        }
    }
}
'Run tests on brstest

' Version using regular print statements
function main()
  BrsTestMain()
end function

' Version using tcp socket to stream output - will wait for connection before starting tests
' function main()
'     print "Waiting for socket connection ..."
'     messagePort = CreateObject("roMessagePort")
'     tcpListen = CreateObject("roStreamSocket")
'     tcpListen.setMessagePort(messagePort)
'     addr = CreateObject("roSocketAddress")
'     addr.setPort(54321)
'
'     tcpListen.setAddress(addr)
'     tcpListen.notifyReadable(true)
'     x = tcpListen.listen(1)
'
'     if not tcpListen.eOK()
'         print "Error creating listen socket"
'         stop
'     end if
'
'     while True
'         msg = wait(0, messagePort)
'
'         if type(msg) = "roSocketEvent"
'             changedID = msg.getSocketID()
'
'             if changedID = tcpListen.getID() and tcpListen.isReadable()
'                 newConnection = tcpListen.accept()
'
'                 if newConnection = Invalid
'                     print "accept failed"
'                 else
'                     print "accepted new connection " newConnection.getID()
'                     newConnection.sendStr("Running tests ...")
'
'                     BrsTestMain(newConnection)
'
'                     newConnection.sendStr("Tests complete. ")
'                     newConnection.close()
'
'                     End
'                 end if
'
'             else
'                 if closed or not newConnection.eOK()
'                     print "closing connection " changedID
'                     newConnection.close()
'                 end if
'             end if
'         end if
'     end while
'
'     print "Main loop exited"
'     tcpListen.close()
' end function



Sub testAdd(t as object)
    t.assertEqual( (1+2), 3)
    t.assertEqual( 0+1, 1)
End Sub

Sub testMultiply(t as object)
    t.assertEqual( (0*10), 0)
    t.assertEqual( (5*8), 40)
End Sub

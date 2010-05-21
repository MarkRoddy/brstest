'This file contains test fixtures that have been shown to or are highly suspected to 
'cause the Roku DVP to crash during their execution.  They are being sequestored as
'to prevent stalling furthor development.  Execute these tests at your own risk.

Sub testTestCase_ValueTostring_roList_Empty(t as Object)
    'Convert an empty roList to a string w/the ValueToString method
    l = CreateObject("roList")
    expected = "->/"
    actual = t.ValueToString(l)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roArray_Empty(t as object) 
    'Proper conversion of an empty roArray object
    array = []
    expected = "[ ]"
    actual = t.ValueToString(array)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roArray_Ints(t as object)
    'Conversion of roArray with int entries
    array = [1,2,3]
    expected = "[ 1, 2, 3 ]"
    actual = t.ValueToString(array)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roArray_NestedArrays(t as object)
    'Convert an array which has another array as one of its elements
    array = [1,[2,3],4]
    expected = "[ 1, [ 2, 3 ], 4 ]"
    actual = t.ValueToString(array)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_EqValues_Lists_AreEqual(t as object)
    'True if two list values are equal
    x = CreateObject("roList")
    x.AddTail(1)
    x.AddTail(2)
    x.AddTail(3)
    y = CreateObject("roList")
    y.AddTail(1)
    y.AddTail(2)
    y.AddTail(3)
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Lists_NotEqual_DifferentLength(t as object)
    'False if two list values are not equal due to having a different length
    x = CreateObject("roList")
    x.AddTail(1)
    x.AddTail(2)
    x.AddTail(3)
    y = CreateObject("roList")
    y.AddTail(1)
    y.AddTail(2)
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Lists_NotEqual_DifferentValues(t as object)
    'False if two list are the same length, but have different entries
    x = CreateObject("roList")
    x.AddTail(1)
    x.AddTail(2)
    x.AddTail(3)
    y = CreateObject("roList")
    y.AddTail(1)
    y.AddTail(2)
    y.AddTail(12)
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Array_NotEqual_FirstIsLonger(t as object)
    'False if the first of two roArrays is longer
    x = [1,2,3]
    y = [1,2]
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Array_NotEqual_SecondIsLonger(t as object)
    'False if the second of two roArrays is longer
    x = [1,2]
    y = [1,2,4]
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Array_NotEqual_SameLength_DifferentValues(t as object)
    'False if two roArrays are the same length but contain different values
    x = [1,2, 6]
    y = [1,2,4]
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub


'Discovered to be causing itermitant crashes on 05/21/10
Sub testTestCase_EqValues_AssocArray_AreEqual(t as object)
    'True if two roAssociativeArrays have the same keys and point to equal values
    x = {Foo:1, Bar:2}
    y = {Foo:1, Bar:2}
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

'Discovered to be causing itermitant crashes on 05/21/10
Sub testTestCase_EqValues_AssocArray_NotEqual_DifferentValues(t as object)
    'False if two roAssociativeArrays have the same keys and point to different values
    x = {Foo:1, Bar:2}
    y = {Foo:1, Bar:5}
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

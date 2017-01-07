'Unit tests for the test case class


Sub testTestCase_ToString_EqualToMethodName(t as object)
    'To string should return the test method name
    methodname = "testfoobar"
    fixture = brstNewTestFixture("", methodname, "", "")
    tc = brstNewTestCase(fixture)
    t.assertEqual(methodname, tc.toString())
End Sub

Sub testTestCase_ShortDescription_EmptyIfNoDescSpecified(t as object)
    'Empty string return if no description specified
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    t.assertEqual("", tc.shortDescription())
End Sub

Sub testTestCase_ShortDescription_OnlyFirstLineReturned(t as object)
    'Only the first line of the test description should be returned
    expected_desc = "This is the first line of the test description"
    full_desc = expected_desc + chr(10) + "This is the second line"
    full_desc = full_desc     + chr(10) + "This is the third line"
    fixture = brstNewTestFixture("", "", full_desc, "")
    tc = brstNewTestCase(fixture)
    t.assertEqual(expected_desc, tc.shortDescription())
End Sub

Sub testTestCase_ShortDescription_SingleLineDescHandled(t as object)
    'Single line description should be returned as itself
    expected_desc = "This is the first line of the test description"
    fixture = brstNewTestFixture("", "", expected_desc, "")
    tc = brstNewTestCase(fixture)
    t.assertEqual(expected_desc, tc.shortDescription())
End Sub

Sub assertEqualMessageForNotEquals(t as object, val1 as object, val2 as object, ExpectedMessage as object)
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string)
        m.ErrorMessage = msg
    end function
    tc.assertEqual(val1, val2)

    ' Manually compare strings instead of using assertEqual() as we are testing
    ' the assertEqual() method
    if "" = tc.ErrorMessage then
        t.fail("No error message was set")
    else if ExpectedMessage <> tc.ErrorMessage then
        err_msg = "Expected Msg: " + chr(34) + ExpectedMessage + chr(34) + chr(10)
        err_msg = err_msg + "Actual Msg:   " + chr(34) + tc.ErrorMessage + chr(34)
        t.fail(err_msg)
    end if
End Sub

Sub assertEqualMessageForEquals(t as object, val1 as object, val2 as object)
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string)
        m.ErrorMessage = msg
    end function
    tc.assertEqual(val1, val2)
    if "" <>  tc.ErrorMessage then
        t.fail("Unexpected Error message: " + tc.ErrorMessage)
    end if
End Sub

Sub assertNotEqualMessageForEquals(t as object, val1 as object, val2 as object, ExpectedMessage as string)
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string)
        m.ErrorMessage = msg
    end function
    tc.assertNotEqual(val1, val2)

    ' Ok to use assertEqual() in this case as we are testting
    ' assertNotEqual()
    t.assertEqual(ExpectedMessage, tc.ErrorMessage)
End Sub

Sub assertNotEqualNoMessageForNotEquals(t as object, val1 as object, val2 as object)
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    tc.ErrorMessage = ""
    tc.fail = function(msg as string)
        m.ErrorMessage = msg
    end function
    tc.assertNotEqual(val1, val2)
    if "" <>  tc.ErrorMessage then
        t.fail("Unexpected Error message: " + tc.ErrorMessage)
    end if
End Sub

Sub testTestCase_assertEqual_TwoStrings_NotEqual(t as object)
    'Error message for two unequal strings yields expected message
    s1 = "This is the first string"
    s2 = "This is the second string"
    expected_msg = Chr(34) + s1 + Chr(34) + " != " + Chr(34) + s2 + Chr(34)
    assertEqualMessageForNotEquals(t, s1, s2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoStrings_AreEqual(t as object)
    'No error message for two equal strings
    s1 = "This is the first string"
    s2 = "This is the first string"
    assertEqualMessageForEquals(t, s1, s2)
End Sub

Sub testTestCase_assertNotEqual_TwoStrings_AreEqual(t as object)
    'Equal string values produces expected error message
    s1 = "This is the first string"
    s2 = "This is the first string"
    expected_msg = Chr(34) + s1 + Chr(34) + " == " + Chr(34) + s2 + Chr(34)
    assertNotEqualMessageForEquals(t, s1, s2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoStrings_NotEqual(t as object)
    'No error message for two different strings
    s1 = "This is the first string"
    s2 = "This is the second string"
    assertNotEqualNoMessageForNotEquals(t, s1, s2)
End Sub

Sub testTestCase_assertEqual_TwoFloats_NotEqual(t as object)
    'Unequal float values produce expected error message
    f1 = 3.14
    f2 = 3.15
    expected_msg = Str(f1) + " !=" + Str(f2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoFloats_AreEqual(t as object)
    'No error message for two equal floats
    f1 = 3.14
    f2 = 3.14
    assertEqualMessageForEquals(t, f1, f2)
End Sub

Sub testTestCase_assertNotEqual_TwoFloats_AreEqual(t as object)
    'Equal float values produces expected error message
    f1 = 3.14
    f2 = 3.14
    expected_msg = Str(f1) + " ==" + Str(f2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoFloats_NotEqual(t as object)
    'No error message for two different floats
    f1 = 3.14
    f2 = 3.15
    assertNotEqualNoMessageForNotEquals(t, f1, f2)
End Sub

Sub testTestCase_assertEqual_TwoDoubles_NotEqual(t as object)
    'Unequal double values produce expected error message
    f1 = 3.14#
    f2 = 3.15#
    expected_msg = Str(f1) + " !=" + Str(f2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoDoubles_AreEqual(t as object)
    'No error message for two equal doubles
    f1 = 3.14#
    f2 = 3.14#
    assertEqualMessageForEquals(t, f1, f2)
End Sub

Sub testTestCase_assertNotEqual_TwoDoubles_AreEqual(t as object)
    'Equal double values produces expected error message
    f1 = 3.14#
    f2 = 3.14#
    expected_msg = Str(f1) + " ==" + Str(f2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, f1, f2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoDoubles_NotEqual(t as object)
    'No error message for two different doubles
    f1 = 3.14#
    f2 = 3.15#
    assertNotEqualNoMessageForNotEquals(t, f1, f2)
End Sub

Sub testTestCase_assertEqual_TwoInts_NotEqual(t as object)
    'Unequal integer values produce expected error message
    i1 = 3
    i2 = 4
    expected_msg = Stri(i1) + " !=" + Stri(i2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoInts_AreEqual(t as object)
    'No error message for two equal integer values
    i1 = 3
    i2 = 3
    assertEqualMessageForEquals(t, i1, i2)
End Sub

Sub testTestCase_assertNotEqual_TwoInts_AreEqual(t as object)
    'Equal integer values produces expected error message
    i1 = 3
    i2 = 3
    expected_msg = Str(i1) + " ==" + Str(i2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoInts_NotEqual(t as object)
    'No error message for two different integers
    i1 = 3
    i2 = 4
    assertNotEqualNoMessageForNotEquals(t, i1, i2)
End Sub

Sub testTestCase_assertEqual_TwoLongIntegers_NotEqual(t as object)
    'Unequal long integer values produce expected error message
    i1 = 3&
    i2 = 4&
    expected_msg = Stri(i1) + " !=" + Stri(i2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertEqual_TwoLongIntegers_AreEqual(t as object)
    'No error message for two equal long integer values
    i1 = 3&
    i2 = 3&
    assertEqualMessageForEquals(t, i1, i2)
End Sub

Sub testTestCase_assertNotEqual_TwoLongIntegers_AreEqual(t as object)
    'Equal long integer values produces expected error message
    i1 = 3&
    i2 = 3&
    expected_msg = Str(i1) + " ==" + Str(i2)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, i1, i2, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_TwoLongIntegers_NotEqual(t as object)
    'No error message for two different long integers
    i1 = 3&
    i2 = 4&
    assertNotEqualNoMessageForNotEquals(t, i1, i2)
End Sub

Sub testTestCase_assertEqual_StrAndInt(t as object)
    'String and Int values yield expected error message
    v1 = "Foo Bar"
    v2 = 3
    expected_msg = Chr(34) + v1 + Chr(34) + " !=" + Str(v2)
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_StrAndFloat(t as object)
    'String and Float values yield expected error message
    v1 = "Foo Bar"
    v2 = 3.14
    expected_msg = Chr(34) + v1 + Chr(34) + " !=" + Str(v2)
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_StrAndDouble(t as object)
    'String and Double values yield expected error message
    v1 = "Foo Bar"
    v2 = 3.14#
    expected_msg = Chr(34) + v1 + Chr(34) + " !=" + Str(v2)
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_StrAndLongInteger(t as object)
    'String and Int values yield expected error message
    v1 = "Foo Bar"
    v2 = 3&
    expected_msg = Chr(34) + v1 + Chr(34) + " !=" + Str(v2)
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_IntAndStr(t as object)
    'Int and string values yield expected error message
    v1 = 3
    v2 = "Foo Bar"
    expected_msg = Str(v1) + " != " + Chr(34) + v2 + Chr(34)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_FloatAndStr(t as object)
    'Float and string values yield expected error message
    v1 = 3.14
    v2 = "Foo Bar"
    expected_msg = Str(v1) + " != " + Chr(34) + v2 + Chr(34)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_DoubleAndStr(t as object)
    'Double and string values yield expected error message
    v1 = 3.14#
    v2 = "Foo Bar"
    expected_msg = Str(v1) + " != " + Chr(34) + v2 + Chr(34)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_LongIntegerAndStr(t as object)
    'LongInteger and string values yield expected error message
    v1 = 3&
    v2 = "Foo Bar"
    expected_msg = Str(v1) + " != " + Chr(34) + v2 + Chr(34)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertEqualMessageForNotEquals(t, v1, v2, expected_msg)
End Sub

Sub testTestCase_assertEqual_FloatAndInt(t as object)
    'Equivalent float and int values should successfully compare
    f = 3.0
    i = 3
    assertEqualMessageForEquals(t, f, i)
End Sub

Sub testTestCase_assertEqual_DoubleAndInt(t as object)
    'Equivalent double and int values should successfully compare
    d = 3.0#
    i = 3
    assertEqualMessageForEquals(t, d, i)
End Sub

Sub testTestCase_assertEqual_LongIntegerAndInt(t as object)
    'Equivalent long integer and int values should successfully compare
    l = 3&
    i = 3
    assertEqualMessageForEquals(t, l, i)
End Sub

Sub testTestCase_assertEqual_IntAndFloat(t as object)
    'Equivalent int and float values should successfully compare
    f = 3.0
    i = 3
    assertEqualMessageForEquals(t, i, f)
End Sub

Sub testTestCase_assertEqual_DoubleAndFloat(t as object)
    'Equivalent double and float values should successfully compare
    f = 3.0
    d = 3.0#
    assertEqualMessageForEquals(t, d, f)
End Sub

Sub testTestCase_assertEqual_LongIntegerAndFloat(t as object)
    'Equivalent long integer and float values should successfully compare
    f = 3.0
    l = 3&
    assertEqualMessageForEquals(t, l, f)
End Sub

Sub testTestCase_assertEqual_IntAndDouble(t as object)
    'Equivalent int and double values should successfully compare
    d = 3.0
    i = 3
    assertEqualMessageForEquals(t, i, d)
End Sub

Sub testTestCase_assertEqual_FloatAndDouble(t as object)
    'Equivalent float and double values should successfully compare
    d = 3.0#
    f = 3.0
    assertEqualMessageForEquals(t, f, d)
End Sub

Sub testTestCase_assertEqual_LongIntegerAndDouble(t as object)
    'Equivalent long integer and double values should successfully compare
    d = 3.0#
    l = 3&
    assertEqualMessageForEquals(t, l, d)
End Sub

Sub testTestCase_assertEqual_IntAndLongInteger(t as object)
    'Equivalent int and long integer values should successfully compare
    l = 3&
    i = 3
    assertEqualMessageForEquals(t, i, l)
End Sub

Sub testTestCase_assertEqual_FloatAndLongInteger(t as object)
    'Equivalent float and long integer values should successfully compare
    l = 3&
    f = 3.0
    assertEqualMessageForEquals(t, f, l)
End Sub

Sub testTestCase_assertEqual_DoubleAndLongInteger(t as object)
    'Equivalent double and long integer values should successfully compare
    l = 3&
    d = 3.0#
    assertEqualMessageForEquals(t, d, l)
End Sub

Sub testTestCase_assertNotEqual_StrAndInt(t as object)
    'No error message for string and int value
    'assertNotEqual() should handle two different types
    v1 = "foo bar"
    v2 = 3
    assertNotEqualNoMessageForNotEquals(t, v1, v2)
End Sub

Sub testTestCase_assertNotEqual_StrAndFloat(t as object)
    'No error message for string and float value
    'assertNotEqual() should handle two different types
    v1 = "foo bar"
    v2 = 3.14
    assertNotEqualNoMessageForNotEquals(t, v1, v2)
End Sub

Sub testTestCase_assertNotEqual_StrAndDouble(t as object)
    'No error message for string and double value
    'assertNotEqual() should handle two different types
    v1 = "foo bar"
    v2 = 3.14#
    assertNotEqualNoMessageForNotEquals(t, v1, v2)
End Sub

Sub testTestCase_assertNotEqual_StrAndLongInteger(t as object)
    'No error message for string and long integer value
    'assertNotEqual() should handle two different types
    v1 = "foo bar"
    v2 = 3&
    assertNotEqualNoMessageForNotEquals(t, v1, v2)
End Sub

Sub testTestCase_assertNotEqual_FloatAndInt(t as object)
    'Equivalent float and int values should cause error
    f = 3.0
    i = 3
    expected_msg = Str(f) + " ==" + Str(i)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, f, i, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_DoubleAndInt(t as object)
    'Equivalent double and int values should cause error
    d = 3.0#
    i = 3
    expected_msg = Str(d) + " ==" + Str(i)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, d, i, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_LongIntegerAndInt(t as object)
    'Equivalent long integer and int values should cause error
    l = 3&
    i = 3
    expected_msg = Str(l) + " ==" + Str(i)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, l, i, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_IntAndFloat(t as object)
    'Equivalent int and float values should cause error
    i = 3
    f = 3.0
    expected_msg = Str(i) + " ==" + Str(f)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, i, f, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_DoubleAndFloat(t as object)
    'Equivalent double and float values should cause error
    d = 3.0
    f = 3.0
    expected_msg = Str(d) + " ==" + Str(f)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, d, f, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_LongIntegerAndFloat(t as object)
    'Equivalent long integer and float values should cause error
    l = 3&
    f = 3.0
    expected_msg = Str(l) + " ==" + Str(f)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, l, f, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_IntAndDouble(t as object)
    'Equivalent int and double values should cause error
    i = 3
    d = 3.0#
    expected_msg = Str(i) + " ==" + Str(d)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, i, d, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_FloatAndDouble(t as object)
    'Equivalent float and double values should cause error
    f = 3.0
    d = 3.0#
    expected_msg = Str(d) + " ==" + Str(f)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, f, d, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_LongIntegerAndDouble(t as object)
    'Equivalent long integer and double values should cause error
    l = 3&
    d = 3.0#
    expected_msg = Str(l) + " ==" + Str(d)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, l, d, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_IntAndLongInteger(t as object)
    'Equivalent int and long integer values should cause error
    i = 3
    l = 3&
    expected_msg = Str(i) + " ==" + Str(l)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, i, l, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_FloatAndLongInteger(t as object)
    'Equivalent float and long integer values should cause error
    f = 3.0
    l = 3&
    expected_msg = Str(f) + " ==" + Str(l)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, f, l, expected_msg)
End Sub

Sub testTestCase_assertNotEqual_DoubleAndLongInteger(t as object)
    'Equivalent double and long integer values should cause error
    d = 3.0#
    l = 3&
    expected_msg = Str(d) + " ==" + Str(l)
    expected_msg = Right(expected_msg, Len(expected_msg) - 1) ' Remove sign padding
    assertNotEqualMessageForEquals(t, d, l, expected_msg)
End Sub

Sub testTestCase_assertInvalid_Invalid(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertInvalid(Invalid)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_MissingProperty(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertInvalid(o.missing)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_Integer(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertInvalid(0)
  if "0 <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_Float(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertInvalid(0.0)
  if "0 <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_Double(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertInvalid(0.0#)
  if "0 <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_LongInteger(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertInvalid(0&)
  if "0 <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_Object(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertInvalid({})
  if "{  } <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertInvalid_string(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertInvalid("")
  if Chr(34) + Chr(34) + " <> Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_Invalid(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertNotInvalid(Invalid)
  if "roInvalid = Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_MissingProperty(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertNotInvalid(o.missing)
  if "roInvalid = Invalid" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_Integer(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertNotInvalid(0)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_Float(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertNotInvalid(0.0)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_Double(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertNotInvalid(0.0#)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_LongInteger(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  tc.assertNotInvalid(0&)
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_Object(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertNotInvalid({})
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_assertNotInvalid_string(t as object)
  fixture = brstNewTestFixture("", "", "", "")
  tc = brstNewTestCase(fixture)
  tc.ErrorMessage = ""
  tc.fail = function(msg as string)
    m.ErrorMessage = msg
  end function
  o = {}
  tc.assertNotInvalid("")
  if "" <> tc.ErrorMessage then
    t.fail("Unexpected Error message: " + tc.ErrorMessage)
  end if
End Sub

Sub testTestCase_ValueTostring_Integer(t as object)
    'Can convert an integer using the ValueToString method
    i = 4
    expected = "4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Integer_Negative(t as object)
    'Can convert a negative integer using the ValueToString method
    i = -4
    expected = "-4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_LongInteger(t as object)
    'Can convert an integer using the ValueToString method
    i = 4&
    expected = "4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_LongInteger_Negative(t as object)
    'Can convert a negative integer using the ValueToString method
    i = -4&
    expected = "-4"
    actual = t.ValueToString(i)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Float(t as Object)
    'Can convert a float value using ValueToString method
    f = 4.3
    expected = "4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Float_Negative(t as Object)
    'Can convert a negative float value using ValueToString method
    f = -4.3
    expected = "-4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Double(t as Object)
    'Can convert a float value using ValueToString method
    f = 4.3#
    expected = "4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Double_Negative(t as Object)
    'Can convert a negative float value using ValueToString method
    f = -4.3#
    expected = "-4.3"
    actual = t.ValueToString(f)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_String(t as object)
    'Can pass a string to the ValueToString method
    s = "Foo Bar"
    expected = Chr(34) + "Foo Bar" + Chr(34)
    actual = t.ValueToString(s)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Bool_True(t as object)
    'Convert a True value w/the ValueToString method
    b = True
    expected = "True"
    actual = t.ValueToString(b)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_Bool_False(t as object)
    'Convert a False value w/the ValueToString method
    b = False
    expected = "False"
    actual = t.ValueToString(b)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roInvalid(t as Object)
    'Convert the roInvalid constant to a string
    invalid_val = CreateObject("roInvalid")
    expected = "roInvalid"
    actual = t.ValueToString(invalid_val)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roAssociativeArray_Empty(t as object)
    'Appropriate converstion of an empty associative array
    aa = {}
    expected = "{  }"
    actual = t.ValueToString(aa)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roAssociativeArray_HandlesNumerics(t as object)
    'Int values in an associative array are converted
    aa = {foo1:1, foo2:2.0, foo3: 3.0#, foo4: 4&}
    expected = "{ foo1 : 1, foo2 : 2, foo3 : 3, foo4 : 4 }"
    actual = t.ValueToString(aa)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roAssociativeArray_NestedWithAnotherAA(t as object)
    'roAssociativeArray with value that is another roAssociativeArray
    aa = {Foo:1, Bar:{Baz:4} }
    expected = "{ bar : { baz : 4 }, foo : 1 }"
    actual = t.ValueToString(aa)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roList_Empty(t as Object)
    'Convert an empty roList to a string w/the ValueToString method
    l = CreateObject("roList")
    expected = "->/"
    actual = t.ValueToString(l)
    t.assertEqual(expected, actual)
End Sub

Sub testTestCase_ValueTostring_roList_Numerics(t as Object)
    'Convert roList of ints w/the ValueToString method
    l = CreateObject("roList")
    l.AddTail(1)
    l.AddTail(2.0)
    l.AddTail(3.0#)
    l.AddTail(4&)
    expected = "1 -> 2 -> 3 -> 4 -> /"
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

Sub testTestCase_ValueTostring_roArray_Numerics(t as object)
    'Conversion of roArray with int entries
    array = [1,2.0,3.0#,4&]
    expected = "[ 1, 2, 3, 4 ]"
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

Sub testTestCase_EqValues_Integers_AreEqual(t as object)
    'True if two integer values are equal
    x = 4
    y = 4
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Integers_NotEqual(t as object)
    'False if two integer values are not equal
    x = 4
    y = 5
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_LongIntegers_AreEqual(t as object)
    'True if two long integer values are equal
    x = 4&
    y = 4&
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_LongIntegers_NotEqual(t as object)
    'False if two long integer values are not equal
    x = 4&
    y = 5&
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Floats_AreEqual(t as object)
    'True if two float values are equal
    x = 4.5
    y = 4.5
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Floats_NotEqual(t as object)
    'False if two float values are not equal
    x = 4.5
    y = 5.5
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Doubles_AreEqual(t as object)
    'True if two doubles values are equal
    x = 4.5#
    y = 4.5#
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Doubles_NotEqual(t as object)
    'False if two doubles values are not equal
    x = 4.5#
    y = 5.5#
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Equal_FloatAndIntValues(t as object)
    'True if equal float and int values are supplied
    x = 3.0
    y = 3
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_DoubleAndIntValues(t as object)
    'True if equal double and int values are supplied
    x = 3.0#
    y = 3
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_LongIntegerAndIntValues(t as object)
    'True if equal long integer and int values are supplied
    x = 3&
    y = 3
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_IntAndFloatValues(t as object)
    'True if equal int and float values are supplied
    x = 3
    y = 3.0
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_DoubleAndFloatValues(t as object)
    'True if equal double and float values are supplied
    x = 3.0#
    y = 3.0
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_LongIntegerAndFloatValues(t as object)
    'True if equal long integer and float values are supplied
    x = 3&
    y = 3.0
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_IntAndDoubleValues(t as object)
    'True if equal int and double values are supplied
    x = 3
    y = 3.0#
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_FloatAndDoubleValues(t as object)
    'True if equal float and double values are supplied
    x = 3.0
    y = 3.0#
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_LongIntegerAndDoubleValues(t as object)
    'True if equal long integer and double values are supplied
    x = 3&
    y = 3.0#
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_IntAndLongIntegerValues(t as object)
    'True if equal int and double values are supplied
    x = 3
    y = 3&
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_FloatAndLongIntegerValues(t as object)
    'True if equal float and double values are supplied
    x = 3.0
    y = 3&
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Equal_DoubleAndLongIntegerValues(t as object)
    'True if equal long integer and double values are supplied
    x = 3.0#
    y = 3&
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Strings_AreEqual(t as object)
    'True if two string values are equal
    x = "Foo Bar"
    y = "Foo Bar"
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Strings_NotEqual(t as object)
    'False if two string values are not equal
    x = "Foo Bar"
    y = "Foo Bar Baz"
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_Bools_AreEqual_True(t as object)
    'True if two bool values are equal
    x = True
    y = True
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Bools_AreEqual_False(t as object)
    'True if two bool values are equal
    x = False
    y = False
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Bools_NotEqual(t as object)
    'False if two bool values are not equal
    x = True
    y = False
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_AssocArray_NotEqual_FirstHasMoreKeys(t as object)
    'False if first of two roAssociativeArrays has more keys
    x = {Foo:1, Bar:2, Baz:4}
    y = {Foo:1, Bar:2}
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_AssocArray_NotEqual_SecondHasMoreKeys(t as object)
    'False if second of two roAssociativeArrays has more keys
    x = {Foo:1, Bar:2}
    y = {Foo:1, Bar:2, Baz:4}
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_AssocArray_NotEqual_DiffKeysSameCount(t as object)
    'False if two roAssociativeArrays have the same number keys but different sets of keys
    x = {Foo:1, Bar:2}
    y = {Foo:1, Baz:2}
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_EqValues_AssocArray_AreEqual(t as object)
    'True if two roAssociativeArrays have the same keys and point to equal values
    x = {Foo:1, Bar:2}
    y = {Foo:1, Bar:2}
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_AssocArray_NotEqual_DifferentValues(t as object)
    'False if two roAssociativeArrays have the same keys and point to different values
    x = {Foo:1, Bar:2}
    y = {Foo:1, Bar:5}
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

sub testTestCase_EqValues_Function_AreEqual(t as object)
    'True if two function arguments are the same function
    x = Function ()
        Return 1
    End Function
    y = x
    result = t.eqValues(x,y)
    t.assertTrue(result)
End Sub

sub testTestCase_EqValues_Function_AreNotEqual(t as object)
    'False if two function arguments are not the same function
    x = Function ()
        Return 1
    End Function
    y = Function ()
        Return 1
    End Function
    result = t.eqValues(x,y)
    t.assertFalse(result)
End Sub

sub testTestCase_EqValues_FunctionOnObject_AreEqual(t as object)
    'True if two function arguments from an 'object' are the same function
    x = t.assertEqual
    y = t.assertEqual
    result = t.eqValues(x,y)
    t.assertTrue(result)
End Sub

sub testTestCase_EqValues_FunctionOnObject_AreNotEqual(t as object)
    'False if two function arguments from the same 'object' are not the same function
    x = t.assertEqual
    y = t.assertNotEqual
    result = t.eqValues(x,y)
    t.assertFalse(result)
End Sub

sub testTestCase_EqValues_FunctionOnDifferentObject_AreNotEqual(t as object)
    'True if two function arguments are from different 'objects' but the
    'same function
    fixture = brstNewTestFixture("", "", "", "")
    tc = brstNewTestCase(fixture)
    x = t.assertEqual
    y = tc.assertEqual
    result = t.eqValues(x,y)
    t.assertTrue(result)
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

Sub testTestCase_EqReference_Node_AreEqual(t as object)
    'True if both nodes have the same reference -- not just all the same fields
    x = CreateObject("roSGNode", "Node")
    y = x
    result = t.eqValues(x, y)
    t.assertTrue(result)
End Sub

Sub testTestCase_EqValues_Node_NotEqual_DifferentReference(t as object)
    'False if two nodes have a different reference, regardless of their field values
    x = CreateObject("roSGNode", "Node")
    y = CreateObject("roSGNode", "Node")
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_Node_NotEqual_DifferentValues(t as object)
    'False if two nodes have a different reference, regardless of their field values
    x = CreateObject("roSGNode", "Node")
    x.addFields( {"foo" : "bar"} )
    y = CreateObject("roSGNode", "Node")
    x.addFields( {"foo" : "baz"} )
    result = t.eqValues(x, y)
    t.assertFalse(result)
End Sub

Sub testTestCase_Node_EqReference_CircularRef_Basic(t as object)
    'True if two nodes have the same reference, even if one contains a reference to itself
    x = CreateObject("roSGNode", "Node")
    x.addFields( {"foo" : x} )
    result = t.eqValues(x, x)
    t.assertTrue(result)
End Sub
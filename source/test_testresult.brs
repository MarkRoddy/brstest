'Unit Tests for the TestResult object


Sub testStopSetsShouldStopToTrue(m)
    'stop() sets shouldStop to True
    tr = brstNewTestResult()
    tr.stop() 'fake test
    m.assertTrue(tr.shouldStop)
End Sub

Sub testShouldStopDefaultsToFalse(m)
    'ShouldStop attribute defaults to False
    tr = brstNewTestResult()
    m.assertFalse(tr.shouldStop)
End Sub

Sub testStartTestIncrementsTestsRun(m)
    'startTest() should increment testsRun attribute by 1
    tr = brstNewTestResult()
    tr.startTest("")
    tr.startTest("")
    tr.startTest("")
    m.assertEqual(3, tr.testsRun)
End Sub

Sub testTestRunDefaultsToZero(m)
    'testsRun attribute should default to zero
    tr = brstNewTestResult()
    m.assertEqual(0, tr.testsRun)
End Sub

Sub testWasSuccessfulAfterFailure(m)
    'wasSuccessful() returns false after a failure is added
    tr = brstNewTestResult()
    tr.addFailure("", "This is a simulated failure")
    m.assertFalse(tr.wasSuccessful())
End Sub

Sub testWasSuccessfulAfterError(m)
    'wasSuccessful() returns false after an error is added
    tr = brstNewTestResult()
    tr.addError("", "This is a simulated error")
    m.assertFalse(tr.wasSuccessful())
End Sub

Sub testWasSuccessfulTrueByDefault(m)
    'wasSuccessful() returns true of no errors or failures were added
    tr = brstNewTestResult()
    m.assertTrue(tr.wasSuccessful())
End Sub
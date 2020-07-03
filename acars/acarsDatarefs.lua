callsignDataref = createDatarefS("cpdlc/callsign", "-------", false, false)
flightNumber = callsignDataref
-- -----------------------------------------------------------------------------
-- ANCHOR COMM datarefs
-- -----------------------------------------------------------------------------
commHeaderId = createDatarefI("cpdlc/headerId", 3)
commPageId = createDatarefI("cpdlc/pageId", 5)
commLeftScratchpad = createDatarefS("cpdlc/scratchpad", "")
commLeftScratchpadKeyboard = createDatarefI("cpdlc/scratchpadKeyboard", 0)
acarsLogonCodeDataref = createDatarefS("cpdlc/logonCode", "")
acarsRemoteServerDataref = createDatarefS("cpdlc/remoteServer", "http://www.hoppie.nl/acars/system/connect.html")
acarsEnabledDataref = createDatarefI("cpdlc/enabled", 0)
acarsActiveDataref = createDatarefI("cpdlc/active", 0)
use833Dataref = createDatarefI("cpdlc/use833", 0)
frameTime = globalPropertyf("sim/time/framerate_period")

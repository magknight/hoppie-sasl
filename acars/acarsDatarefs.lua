callsignDataref = createDatarefS("aero787/general/flightNumber", "-------", false, false)
flightNumber = callsignDataref
-- -----------------------------------------------------------------------------
-- ANCHOR COMM datarefs
-- -----------------------------------------------------------------------------
commHeaderId = createDatarefI("aero787/cockpit/comm/headerId", 3)
commPageId = createDatarefI("aero787/cockpit/comm/pageId", 5)
commLeftScratchpad = createDatarefS("aero787/cockpit/comm/leftScratchpad", "")
commLeftScratchpadKeyboard = createDatarefI("aero787/cockpit/comm/leftScratchpadKeyboard", 0)
acarsLogonCodeDataref = createDatarefS("aero787/acars/logonCode", "")
acarsRemoteServerDataref = createDatarefS("aero787/acars/remoteServer", "")
acarsEnabledDataref = createDatarefI("aero787/acars/enabled", 0)
acarsActiveDataref = createDatarefI("aero787/acars/active", 0)
use833Dataref = createDatarefI("aero787/acars/use833", 0)
frameTime = globalPropertyf("sim/time/framerate_period")

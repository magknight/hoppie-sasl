customDatarefs = {}
customCommands = {}
function createDatarefI(name, default, unitsA, descriptionA)
	table.insert(customDatarefs, {dataref = name, type = "int", writable = "y", unit = unitsA or "???", description = descriptionA or "???"})
	return createGlobalPropertyi(name, default)
end
function createDatarefIA(name, default, unitsA, descriptionA)
	table.insert(customDatarefs, {dataref = name, type = "intArray", writable = "y", unit = unitsA or "???", description = descriptionA or "???"})
	return createGlobalPropertyia(name, default)
end
function createDatarefF(name, default, unitsA, descriptionA)
	table.insert(customDatarefs, {dataref = name, type = "float", writable = "y", unit = unitsA or "???", description = descriptionA or "???"})
	return createGlobalPropertyf(name, default)
end
function createDatarefFA(name, default, unitsA, descriptionA)
	table.insert(customDatarefs, {dataref = name, type = "floatArray", writable = "y", unit = unitsA or "???", description = descriptionA or "???"})
	return createGlobalPropertyfa(name, default)
end
function createDatarefS(name, default, unitsA, descriptionA)
	table.insert(customDatarefs, {dataref = name, type = "string", writable = "y", unit = unitsA or "???", description = descriptionA or "???"})
	return createGlobalPropertys(name, default)
end
function createCommand(name, joystickCodeA, descriptionA)
	table.insert(customCommands, {command = name, description = descriptionA or "???", joystickCode = joystickCodeA or "???"})
	return sasl.createCommand(name, joystickCodeA or "")
end

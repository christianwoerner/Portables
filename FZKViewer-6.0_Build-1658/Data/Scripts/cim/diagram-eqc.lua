--[[
Available functions:
query_object - Queries object by type; example: query_object("cim:Diagram")
]]--

EXPLODE_FACTOR = 5.0

-- Everything derived from EquipmentContainer
EQUIPMENT_CONTAINER = {}
EQUIPMENT_CONTAINER["cim:EquipmentContainer"] = true
EQUIPMENT_CONTAINER["cim:Bay"] = true
EQUIPMENT_CONTAINER["cim:Substation"] = true
EQUIPMENT_CONTAINER["cim:VoltageLevel"] = true
EQUIPMENT_CONTAINER["cim:Line"] = true
EQUIPMENT_CONTAINER["cim:Plant"] = true
EQUIPMENT_CONTAINER["cim:DCConverterUnit"] = true
EQUIPMENT_CONTAINER["cim:DCLine"] = true
EQUIPMENT_CONTAINER["cim:DCEquipmentContainer"] = true
EQUIPMENT_CONTAINER["cim:MktLine"] = true


--------------------------- Helpers

function object_position(expectedDiagramName, object)
	diagramObjects = query_attribute_reverse(object, "cim:DiagramObject.IdentifiedObject")

	for _, diagramObject in ipairs(diagramObjects) do
		diagrams = query_attribute(diagramObject, "cim:DiagramObject.Diagram")

		diagramName = as_string(diagrams[1])

		print(expectedDiagramName, " == ", diagramName)

		if diagramName == expectedDiagramName then
			positions = query_attribute_reverse(diagramObject, "cim:DiagramObjectPoint.DiagramObject")
			
			if positions ~= nil and #positions > 0 then
				x = 0
				y = 0

				for _, position in ipairs(positions) do
					x = x + query_value(position, "cim:DiagramObjectPoint.xPosition")
					y = y + query_value(position, "cim:DiagramObjectPoint.yPosition")	
				end

				x = x / #positions
				y = y / #positions

				result = {}
				result.x = x
				result.y = y

				return result
			end
		end
	end

	return nil
end

function diagram_object_position(diagramObject)
	diagramObjectPositions = query_attribute_reverse(diagramObject, "cim:DiagramObjectPoint.DiagramObject")

	x = 0
	y = 0

	for _, diagramObjectPosition in ipairs(diagramObjectPositions) do
		x = x + query_value(diagramObjectPosition, "cim:DiagramObjectPoint.xPosition")
		y = y + query_value(diagramObjectPosition, "cim:DiagramObjectPoint.yPosition")	
	end

	result = {}
	result.x = x / #diagramObjectPositions * EXPLODE_FACTOR
	result.y = y / #diagramObjectPositions * EXPLODE_FACTOR

	return result
end

--- subtransformations

ignore = {}
ignore["cim:Terminal"] = true
-- ACHTUNG! ConnectivityNode MUST be ignored
ignore["cim:ConnectivityNode"] = true

ignore["cim:DiagramObject"] = true
ignore["cim:DiagramObjectPoint"] = true
ignore["cim:Diagram"] = true

ignore["cim:LoadAggregate"] = true
ignore["cim:LoadStatic"] = true
ignore["cim:LoadResponseCharacteristic"] = true

ignore["cim:OperationalLimitSet"] = true
ignore["cim:OperationalLimitType"] = true
ignore["cim:Location"] = true
ignore["cim:CurrentLimit"] = true
ignore["cim:CoordinateSystem"] = true
ignore["cim:PositionPoint"] = true
ignore["cim:VoltageLevel"] = true
ignore["cim:BaseVoltage"] = true
ignore["cim:Substation"] = true
ignore["cim:SubGeographicalRegion"] = true
ignore["cim:GeographicalRegion"] = true

ignore["cim:TopologicalIsland"] = true
ignore["cim:TopologicalNode"] = true

ignore["cim:SvVoltage"] = true
ignore["cim:SvPowerFlow"] = true
ignore["cim:SvTapStep"] = true

endAttributeNames = { "cim:PowerTransformerEnd.PowerTransformer", "cim:RotatingMachine.GeneratingUnit", "cim:RatioTapChanger.TransformerEnd" }

function get_connectivity_nodes(objects)
	terminals = query_attribute_reverse(objects, "cim:Terminal.ConductingEquipment")
	local connectivityNodes = query_attribute(terminals, "cim:Terminal.ConnectivityNode")
	return connectivityNodes
end

function transform_intelligent(objects, exists, ends)
	for _, object in ipairs(objects) do
		objectName = as_string(object)
				
		append_container_hint(object, hints)
		make_node(objectName, object)
		
		connectivityNodes = get_connectivity_nodes(object)

		for _, connectivityNode in ipairs(connectivityNodes) do
			connectivityNodeName = as_string(connectivityNode)

			if exists[connectivityNodeName] == nil then
				exists[connectivityNodeName] = true
						
				append_container_hint(object, hints)
				make_node(connectivityNodeName, connectivityNode)
			end

			make_edge(objectName, connectivityNodeName, nil)
		end

		for _, endAttributeName in ipairs(endAttributeNames) do
			endObjects = query_attribute(object, endAttributeName)

			for _, endObject in ipairs(endObjects) do
					
				endName = as_string(endObject)

				table.insert(ends, { first = endName, second = objectName })
			end
		end
	end
end

function transform_star()
	print("Transforming star")

	types = query_types()

	exists = {}
	ends = {}

	for _, type in ipairs(types) do
		if ignore[type] == nil then
			objects = query_object(type)

			transform_intelligent(objects, exists, ends)
		end	
	end

	for _, en in ipairs(ends) do
		make_edge(en.first, en.second, nil)
	end
end

function append_container_hint(object, hints)
	local objectType = query_type(object)

	if EQUIPMENT_CONTAINER[objectType] == true then
		hints["transform"] = "eqc"
		hints["transform_root"] = as_string(object)
	end
end

function transform_equipment_container(equipmentContainerStr)
	local objects = query_object_name(equipmentContainerStr)

	for _, object in ipairs(objects) do
		local objectType = query_type(object)
		
		if EQUIPMENT_CONTAINER[objectType] == nil then
			print("Object is not an EquipmentContainer")
		end

		local equipmentObjects = query_attribute_reverse(object, "cim:Equipment.EquipmentContainer")

		exists = {}
		ends = {}

		--transform_intelligent(equipmentObjects, exists, ends)
		
		local substationObjects = query_attribute(object, "cim:VoltageLevel.Substation")
		local equipmentObjects = query_attribute_reverse(substationObjects, "cim:Equipment.EquipmentContainer")
		
		--transform_intelligent(equipmentObjects, exists, ends)	
		
		local connectivityNodeObjects = get_connectivity_nodes(equipmentObjects)	
		-- All CNs in the same container
		local temp1 = query_attribute(connectivityNodeObjects, "cim:ConnectivityNode.ConnectivityNodeContainer")
		local temp2 = query_attribute_reverse(temp1, "cim:ConnectivityNode.ConnectivityNodeContainer")
		-- All terminals in the containers
		local temp3 = query_attribute_reverse(temp2, "cim:Terminal.ConnectivityNode")
		-- All objects in the containers
		local equipmentObjects = query_attribute(temp3, "cim:Terminal.ConductingEquipment")
		
		transform_intelligent(equipmentObjects, exists, ends)	
	end
end

function transform_diagram(diagramStr)
	visited = {}

	diagrams = query_object("cim:Diagram")

	rootDiagram = nil

	for _, diagram in ipairs(diagrams) do
		if as_string(diagram) == diagramStr then
			rootDiagram = diagram
			break
		end
	end

	if rootDiagram == nil then
		print("Root diagram not found")
	end
	
	diagramObjects = query_attribute_reverse(rootDiagram, "cim:DiagramObject.Diagram")

	print(#diagramObjects .. " cim:DiagramObject found")

	delayedObjects = {}

	for _, diagramObject in ipairs(diagramObjects) do
		objects = query_attribute(diagramObject, "cim:DiagramObject.IdentifiedObject")

		position = diagram_object_position(diagramObject)

		for _, object in ipairs(objects) do
			hints = {}	

			if (position ~= nil) then
				hints["x"] = position.x -- * EXPLODE_FACTOR
				hints["y"] = position.y -- * EXPLODE_FACTOR
			end

			objectName = as_string(object)
			objectType = query_type(object)

			if objectType ~= "cim:Terminal" then -- and objectType ~= "cim:ConnectivityNode" then
				append_container_hint(object, hints)

				make_node(objectName, object, hints)
				delayedObjects[objectName] = true
			end
		end
	end

	local connectivityNodes = query_object("cim:ConnectivityNode")

	for _, connectivityNode in ipairs(connectivityNodes) do
		-- Spezialbehandlung ConnectivityNode in Diagramm
		local connectivityNodeName = as_string(connectivityNode)
		
		if delayedObjects[connectivityNodeName] == true then
			print("Spezialbehandlung")

			-- Ist ein ConnectivityNodeContainer vorhanden?
			temp1 = query_attribute(connectivityNode, "cim:ConnectivityNode.ConnectivityNodeContainer")
			temp2 = query_attribute_reverse(temp1, "cim:ConnectivityNode.ConnectivityNodeContainer")

			terminals = query_attribute_reverse(temp2, "cim:Terminal.ConnectivityNode")
			objects = query_attribute(terminals, "cim:Terminal.ConductingEquipment")

			-- Gibt es ein Object das mit diesem Container verbunden ist?
			for _, object in ipairs(objects) do
				local objectName = as_string(object)

				if delayedObjects[objectName] == true then
					make_edge(connectivityNodeName, objectName, nil)
				end
			end
		end
		-- Ende Spezialbehandlung
	end

	for _, connectivityNode in ipairs(connectivityNodes) do
		-- Wenn der CN ein explizities DiagramObject ist, dann muss keine Direktverbindung zwischen
		-- Containern/ConductingEquipment hergestellt werden.

		if delayedObjects[as_string(connectivityNode)] ~= true then
			terminals = query_attribute_reverse(connectivityNode, "cim:Terminal.ConnectivityNode")
			objects = query_attribute(terminals, "cim:Terminal.ConductingEquipment")

			closedObjects = {}

			for _, object1 in ipairs(objects) do
				for _, object2 in ipairs(objects) do
					objectName1 = as_string(object1)
					objectName2 = as_string(object2)

					if closedObjects[objectName1 .. objectName2] == nil then
						closedObjects[objectName1 .. objectName2] = true
						closedObjects[objectName2 .. objectName1] = true

						if delayedObjects[objectName1] == nil and delayedObjects[objectName2] == true then
							objects1 = query_attribute(object1, "cim:Equipment.EquipmentContainer")

							if #objects1 == 1 then
								objectName1 = as_string(objects1[1])
							end
						end

						if delayedObjects[objectName2] == nil and delayedObjects[objectName1] == true then
							objects2 = query_attribute(object2, "cim:Equipment.EquipmentContainer")

							if #objects2 == 1 then
								objectName2 = as_string(objects2[1])
							end					
						end

						if delayedObjects[objectName1] == true and delayedObjects[objectName2] == true then
							make_edge(objectName1, objectName2, nil)
						end
					end
				end
			end	
		end
	end
end

function transform_everything()
	diagrams = query_object("cim:Diagram")

	x = 0.0

	for _, diagram in ipairs(diagrams) do
		hints = {}
		hints["transform"] = "subdiagram"
		hints["transform_root"] = as_string(diagram)
		hints["x"] = x

		make_node(as_string(diagram), diagram, hints)

		x = x + 100
	end

	hints = {}
	hints["transform"] = "*"
	hints["label"] = "*"
	hints["x"] = x

	make_node("Everything", nil, hints)
end

if PARAMETERS["transform"] ~= nil then
	if PARAMETERS["transform"] == "subdiagram" then
		print("Transforming subdiagram...")
		transform_diagram(PARAMETERS["transform_root"])
	elseif PARAMETERS["transform"] == "eqc" then
		print("Transforming EquipmentContainer...")
		transform_equipment_container(PARAMETERS["transform_root"])
	elseif PARAMETERS["transform"] == "*" then
		print("Transforming *...")
		transform_star()
	end
else
	print("Transforming /...")
	transform_everything()
end

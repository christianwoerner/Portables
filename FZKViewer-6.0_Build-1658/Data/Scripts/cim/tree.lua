types = query_types()

function make_object(parentName, object)
	objectName = as_string(object)
	make_node(objectName, object)
	make_edge(parentName, objectName, nil)

	terminals = query_attribute_reverse(object, "cim:Terminal.ConductingEquipment")
	
	for _, terminal in ipairs(terminals) do
		terminalName = as_string(terminal)
		make_node(terminalName, terminal)
		make_edge(objectName, terminalName, nil)
	end

	ends = query_attribute_reverse(object, "cim:PowerTransformerEnd.PowerTransformer")

	for _, en in ipairs(ends) do
		endName = as_string(en)
		make_node(endName, en)
		make_edge(objectName, endName, nil)
		
		print("Appending PowerTransformerEnd")
	end

	ends = query_attribute_reverse(object, "cim:RotatingMachine.GeneratingUnit")

	for _, en in ipairs(ends) do
		endName = as_string(en)
		make_node(endName, en)
		make_edge(objectName, endName, nil)
		
		print("Appending RotatingMachine")
	end
end

function make_objects(typeName)
	hints = {}
	hints["label"] = typeName
	hints["root"] = "yes"

	make_node(typeName, nil, hints)

	for _, object in ipairs(query_object(typeName)) do
		make_object(typeName, object)
	end
end

function make_connectivity_node(typeName)
	hints = {}
	hints["label"] = typeName
	hints["root"] = "yes"

	make_node(typeName, nil, hints)

	for _, connectivityNode in ipairs(query_object(typeName)) do
		connectivityNodeName = as_string(connectivityNode)
		make_node(connectivityNodeName, connectivityNode)
		make_edge(typeName, connectivityNodeName, nil)

		terminals = query_attribute_reverse(connectivityNode, "cim:Terminal.ConnectivityNode")
		objects = query_attribute(terminals, "cim:Terminal.ConductingEquipment")

		for _, object in ipairs(objects) do
			make_node(connectivityNodeName .. as_string(object), object)
			make_edge(connectivityNodeName, connectivityNodeName .. as_string(object), nil)
		end
	end
end

function make_nop(typeName)
end

factory = {}
factory["cim:Terminal"] = make_nop
--factory["cim:Diagram"] = make_nop
factory["cim:DiagramObject"] = make_nop
factory["cim:PositionPoint"] = make_nop
factory["cim:DiagramObjectPoint"] = make_nop
--factory["cim:ConnectivityNode"] = make_object
factory["cim:SynchronousMachine"] = make_nop
factory["cim:PowerTransformerEnd"] = make_nop

for _, type in ipairs(types) do
	if factory[type] == nil then
		make_objects(type)
	else
		factory[type](type)
	end
end
function query()
	diagrams = query_object("cim:Diagram")

	for _, diagram in ipairs(diagrams) do
		hints = {}
		hints["hasDiagram"] = "true"
		make_node(as_string(diagram), diagram, hints)
	end

	pps = query_object("cim:PositionPoint")

	for _, pp in ipairs(pps) do
		hints = {}
		hints["hasGeometry"] = "true"
		make_node(as_string(pp), pp, hints)
	end
end

query()
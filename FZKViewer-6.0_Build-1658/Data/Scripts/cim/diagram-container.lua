objects = query_object("cim:ConnectivityNode")

for _, object in ipairs(objects) do
	containers = query_attribute(object, "cim:ConnectivityNode.ConnectivityNodeContainer")


end
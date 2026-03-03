local CFrameBufferUtil = {}

local FLOAT_SIZE = 4
local COMPONENT_COUNT = 12
local TOTAL_SIZE = FLOAT_SIZE * COMPONENT_COUNT -- 48 bytes

CFrameBufferUtil.BYTE_SIZE = TOTAL_SIZE

function CFrameBufferUtil.Serialize(cf: CFrame): buffer
	local buf = buffer.create(TOTAL_SIZE)

	local components = { cf:GetComponents() }
	local offset = 0

	for i = 1, COMPONENT_COUNT do
		buffer.writef32(buf, offset, components[i])
		offset += 4
	end

	return buf
end

function CFrameBufferUtil.Deserialize(buf: buffer): CFrame
	local components = table.create(COMPONENT_COUNT)
	local offset = 0

	for i = 1, COMPONENT_COUNT do
		components[i] = buffer.readf32(buf, offset)
		offset += 4
	end

	return CFrame.new(table.unpack(components))
end

return CFrameBufferUtil

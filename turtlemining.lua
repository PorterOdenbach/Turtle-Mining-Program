local scanner = peripheral.find('geoScanner')

function scanBlocks(range)
    local scan, error = scanner.scan(range)
    if scan then
        return scan
    end
    return error
end

print(textutils.serialize(scanBlocks(16)))
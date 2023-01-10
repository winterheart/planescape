package main

import (
    "encoding/binary"
    "fmt"
    "log"
    "os"
)

type zipLocalHeader struct {
    Signature                uint32
    Version                  uint16
    Flags                    uint16
    CompressionMethod        uint16
    FileLastModificationTime uint16
    FileLastModificationDate uint16
    CRC32                    uint32
    CompressedSize           uint32
    UncompressedSize         uint32
    FilenameLength           uint16
    ExtraFieldLength         uint16
}

type LocalHeader struct {
    zip        zipLocalHeader
    Filename   []byte
    ExtraField []byte
}

type zipCentralHeader struct {
    Signature                uint32
    VersionMadeBy            uint16
    VersionNeededToExtract   uint16
    Flags                    uint16
    CompressionMethod        uint16
    FileLastModificationTime uint16
    FileLastModificationDate uint16
    CRC32                    uint32
    CompressedSize           uint32
    UncompressedSize         uint32
    FilenameLength           uint16
    ExtraFieldLength         uint16
    FileCommentLength        uint16
    DiskNumber               uint16
    InternalFileAttributes   uint16
    ExternalFileAttributes   uint32
    RelativeOffset           uint32
}

type CentralHeader struct {
    zip         zipCentralHeader
    Filename    []byte
    ExtraField  []byte
    FileComment []byte
}

type zipEndCentralHeader struct {
    Signature              uint32
    DiskNumber             uint16
    DiskCentralDir         uint16
    NumCentralDirRecords   uint16
    TotalCentralDirRecords uint16
    SizeOfCentralDir       uint32
    CentralDirOffset       uint32
    CommentLength          uint16
}

type EndCentralHeader struct {
    zip     zipEndCentralHeader
    Comment []byte
}

func (header *LocalHeader) ValidSignature() bool {
    return header.zip.Signature == 0x04034b50
}

func (header *LocalHeader) CompressedDataAt() int {
    return int(header.zip.FilenameLength) + int(header.zip.ExtraFieldLength)
}

func (header *LocalHeader) HasDataDesciptor() bool {
    return header.zip.Flags&0x08 != 0

}

func (header *CentralHeader) ValidSignature() bool {
    return header.zip.Signature == 0x02014b50
}

func (header *CentralHeader) NextHeaderAt() int {
    return int(header.zip.FilenameLength) + int(header.zip.ExtraFieldLength) + int(header.zip.FileCommentLength)
}

func (header *CentralHeader) Compare(local LocalHeader) bool {
    return header.zip.FilenameLength+header.zip.ExtraFieldLength == local.zip.FilenameLength+local.zip.ExtraFieldLength
}

func (header *CentralHeader) Import(local LocalHeader) {
    header.zip.FilenameLength = local.zip.FilenameLength
    header.Filename = local.Filename
    header.zip.ExtraFieldLength = local.zip.ExtraFieldLength
    header.ExtraField = local.ExtraField
}

func (header *EndCentralHeader) ValidSignature() bool {
    return header.zip.Signature == 0x06054b50
}

func main() {
    fmt.Printf("Fixing central directory on: %s\n", os.Args[1])
    zipFile, err := os.OpenFile(os.Args[1], os.O_RDWR, 0666)
    if err != nil {
        log.Fatal(err)
    }
    defer zipFile.Close()
    zipFile.Seek(0, os.SEEK_SET)

    localHeaders := make([]LocalHeader, 0)

    for {
        var signature uint32
        var header LocalHeader

        err = binary.Read(zipFile, binary.LittleEndian, &header.zip)
        if err != nil {
            log.Fatal(err)
        }
        if !header.ValidSignature() {
            if header.zip.Signature == 0x02014b50 {
                // we ran out of local headers, and are at the central directory, so seek back the size we just read
                zipFile.Seek(int64(-1*binary.Size(header.zip)), os.SEEK_CUR)
            }

            break
        }
        header.Filename = make([]byte, header.zip.FilenameLength)
        err = binary.Read(zipFile, binary.LittleEndian, &header.Filename)
        header.ExtraField = make([]byte, header.zip.ExtraFieldLength)
        err = binary.Read(zipFile, binary.LittleEndian, &header.ExtraField)

        zipFile.Seek(int64(header.zip.CompressedSize), os.SEEK_CUR)

        if header.HasDataDesciptor() {
            err = binary.Read(zipFile, binary.LittleEndian, &signature)
            if err != nil {
                log.Fatal(err)
            }
            if signature == 0x08074b50 {
                zipFile.Seek(12, os.SEEK_CUR)
            } else {
                zipFile.Seek(8, os.SEEK_CUR)
            }
        }
        localHeaders = append(localHeaders, header)
    }
    centralStart, _ := zipFile.Seek(0, os.SEEK_CUR)

    centralHeaders := make([]CentralHeader, 0)
    for _ = range localHeaders {
        var header CentralHeader
        err = binary.Read(zipFile, binary.LittleEndian, &header.zip)
        if err != nil {
            log.Fatal(err)
        }

        if !header.ValidSignature() {
            log.Fatal("Invalid signature")
        }

        header.Filename = make([]byte, header.zip.FilenameLength)
        err = binary.Read(zipFile, binary.LittleEndian, &header.Filename)
        header.ExtraField = make([]byte, header.zip.ExtraFieldLength)
        err = binary.Read(zipFile, binary.LittleEndian, &header.ExtraField)
        header.FileComment = make([]byte, header.zip.FileCommentLength)
        err = binary.Read(zipFile, binary.LittleEndian, &header.FileComment)

        centralHeaders = append(centralHeaders, header)
    }

    var endHeader EndCentralHeader
    err = binary.Read(zipFile, binary.LittleEndian, &endHeader.zip)
    if err != nil {
        log.Fatal(err)
    }

    if !endHeader.ValidSignature() {
        log.Fatal("Zip did not have a proper end signature")
    }
    rewriteCentral := false
    for idx, central := range centralHeaders {
        local := localHeaders[idx]
        if !central.Compare(local) {
            fmt.Printf("Local and Central headers missmatch: %s %d\n", string(central.Filename), central.zip.ExtraFieldLength)
            central.Import(local)
            centralHeaders[idx] = central
            fmt.Printf("Now: %d\n", central.zip.ExtraFieldLength)
            fmt.Printf("Header: %v\n", central.zip)
            rewriteCentral = true
        }
    }

    if rewriteCentral {
        fmt.Printf("Rewriting central directory\n")
        zipFile.Seek(centralStart, os.SEEK_SET)
		centralSize := 0
        for _, central := range centralHeaders {
            err = binary.Write(zipFile, binary.LittleEndian, &central.zip)
            if err != nil {
                log.Fatal(err)
            }
			centralSize += binary.Size(central.zip)
            err = binary.Write(zipFile, binary.LittleEndian, &central.Filename)
            if err != nil {
                log.Fatal(err)
            }
			centralSize += binary.Size(central.Filename)
            err = binary.Write(zipFile, binary.LittleEndian, &central.ExtraField)
            if err != nil {
                log.Fatal(err)
            }
			centralSize += binary.Size(central.ExtraField)
            err = binary.Write(zipFile, binary.LittleEndian, &central.FileComment)
            if err != nil {
                log.Fatal(err)
            }
			centralSize += binary.Size(central.FileComment)
        }
		fmt.Printf("Central Size: %d %d\n", endHeader.zip.SizeOfCentralDir, centralSize)
		endHeader.zip.SizeOfCentralDir = uint32(centralSize)
        err = binary.Write(zipFile, binary.LittleEndian, &endHeader.zip)
        if err != nil {
            log.Fatal(err)
        }
        err = binary.Write(zipFile, binary.LittleEndian, &endHeader.Comment)
        if err != nil {
            log.Fatal(err)
        }
        zipFile.Sync()
    } else {
        fmt.Printf("Local headers match central directory\n")
    }
}


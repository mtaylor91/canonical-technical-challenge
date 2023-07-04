package shred

import (
	"crypto/rand"
	"io"
	"os"
	"syscall"
)

type UnsupportedFileType struct{}

func (e UnsupportedFileType) Error() string {
	return "Unsupported file type"
}

// Shred overwrites a file with random data 3 times and then unlinks it.
func Shred(file string) error {

	// Get the file info
	stat, err := os.Lstat(file)
	if err != nil {
		return err
	} else if !stat.Mode().IsRegular() {
		return UnsupportedFileType{}
	}

	// Open the file with O_DIRECT (bypassing the OS cache) and O_RDWR
	f, err := os.OpenFile(file, syscall.O_DIRECT|os.O_RDWR, 0666)
	if err != nil {
		return err
	}

	// Refresh file info
	stat, err = f.Stat()
	if err != nil {
		return err
	}

	// Get the file size
	sizeBytes := stat.Size()

	// Close the file when we're done
	defer f.Close()

	// Overwrite with random data 3 times
	for i := 0; i < 3; i++ {
		// Seek to the beginning of the file
		if _, err := f.Seek(0, 0); err != nil {
			return err
		}

		// Overwrite the file with random data
		if _, err := io.CopyN(f, rand.Reader, sizeBytes); err != nil {
			return err
		}

		// Sync the file to disk
		if err := f.Sync(); err != nil {
			return err
		}
	}

	// Unlink the file
	return os.Remove(file)
}

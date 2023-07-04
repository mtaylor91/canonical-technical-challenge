package shred

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func createFile(t *testing.T, file string) {
	f, err := os.Create(file)
	assert.NoError(t, err)
	defer f.Close()
}

func testShredSuccess(t *testing.T, file string) {
	// Create test file
	createFile(t, file)
	assert.FileExists(t, file)
	// Shred the file
	err := Shred(file)
	assert.NoError(t, err)
	// Check that the file is gone
	assert.NoFileExists(t, file)
}

func testShredFailDoesNotExist(t *testing.T, file string) {
	// Shred the file
	err := Shred(file)
	assert.Error(t, err)
}

func testShredFailOnDir(t *testing.T, dir string) {
	// Create test dir
	err := os.Mkdir(dir, 0755)
	assert.NoError(t, err)
	defer os.RemoveAll(dir)
	assert.DirExists(t, dir)
	// Shred the dir
	err = Shred(dir)
	assert.Error(t, err)
}

func testShredFailOnSymlink(t *testing.T, file, symlink string) {
	// Create test symlink
	createFile(t, file)
	assert.FileExists(t, file)
	defer os.Remove(file)
	err := os.Symlink(file, symlink)
	assert.NoError(t, err)
	defer os.Remove(symlink)
	assert.FileExists(t, symlink)
	// Shred the symlink
	err = Shred(symlink)
	assert.Error(t, err)
}

func TestShred(t *testing.T) {
	testShredSuccess(t, "test_file")
	testShredFailDoesNotExist(t, "test_file")
	testShredFailOnDir(t, "test_dir")
	testShredFailOnSymlink(t, "test_file", "test_symlink")
}

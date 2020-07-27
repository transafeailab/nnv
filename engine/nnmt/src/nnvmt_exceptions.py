#define Python user-defined exceptions
class Error(Exception):
    """Base class for other exceptions"""
    pass
class FileExtensionError(Error):
    """Raised when the file extension is invalid"""
    pass
class OutputFormatError(Error):
    """Raise when the Output format is invalid"""
    pass


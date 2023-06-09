String getFileType(String fileName) {
  // Get the file extension from the file name
  String fileExtension = fileName.split('.').last.toLowerCase();

  // Determine the file type based on the file extension
  switch (fileExtension) {
    case 'pdf':
      return 'PDF';
    case 'doc':
    case 'docx':
      return 'Word document';
    case 'xls':
    case 'xlsx':
      return 'Excel document';
    case 'ppt':
    case 'pptx':
      return 'PowerPoint presentation';
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return 'Image';
    case 'txt':
      return 'Plain Text';
    case 'wav':
    case 'mp3':
      return 'Audio';
    case 'avi':
    case 'flv':
    case 'm4v':
    case 'mp4':
      return 'Video';
    default:
      return 'Unknown';
  }
}

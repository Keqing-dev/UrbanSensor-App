class GeneralUtil {
  static bool isVideoFormat(String value) {
    final videoFormat = value.replaceAllMapped(RegExp('.[^]*\\.'), (_) {
      return '';
    });
    switch (videoFormat.toLowerCase()) {
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'flv':
      case 'mov':
      case 'wmv':
      case 'divx':
      case 'xvid':
      case 'rm':
      case 'rmvb':
      case 'mks':
      case '3gpp':
        return true;
      default:
        return false;
    }
  }

  static bool isAudioFormat(String value) {
    final videoFormat = value.replaceAllMapped(RegExp('.[^]*\\.'), (_) {
      return '';
    });
    switch (videoFormat.toLowerCase()) {
      case 'mp3':
      case 'aac':
        return true;
      default:
        return false;
    }
  }
}

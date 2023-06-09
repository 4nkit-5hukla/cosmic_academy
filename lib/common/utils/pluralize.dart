String pluralize(
  int count,
  String noun,
) {
  if (count == 1) {
    return '$count $noun';
  } else {
    if (noun.endsWith('y')) {
      return '$count ${noun.substring(0, noun.length - 1)}ies';
    } else if (noun.endsWith('s') ||
        noun.endsWith('ch') ||
        noun.endsWith('sh')) {
      return '$count ${noun}es';
    } else {
      return '$count ${noun}s';
    }
  }
}

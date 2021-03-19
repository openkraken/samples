if (!document.createEvent) {
  // Since createEvent has been deprecated, but it is used in Vue, it needs to be supported by polyfill.
  document.createEvent = () => {
    return new Event('');
  }
}

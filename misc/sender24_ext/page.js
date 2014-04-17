chrome.extension.onRequest.addListener(function(request) {
  if (request.value !== undefined)
    document.getElementsByName(request.name)[0].value = request.value;
  if (request.name === 'e_to_postal_code')
    $('[name=e_to_postal_code]').trigger('blur')
});

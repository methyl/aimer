function parseVal(val){
  address = val.match(/adres:[^]+/)[0].split('\n').splice(2,4);
  items = val.match(/przyj.te:[^]*Zesp../)[0].split('\n');
  items = items.slice(2,items.length-1);
  return $.extend(parseAddress(address), parseItems(items));
}

function parseAddress(lines) {
  name = lines[0];
  street = lines[1].match(/(.+) \d/)[1];
  house = lines[1].match(/ (\d+)\/?/)[1];
  locale = lines[1].match(/ \d+\/?(.+)?/)[1];
  postal_code = lines[2].match(/\d{2}\-\d{3}/)[0];
  city = lines[2].match(/\d{2}\-\d{3}(.+)/)[1].trim();
  phone = lines[3].replace(/ /g,'').replace(/-/g,'');
  return {
      e_to_name: name,
      e_to_person: name,
      e_to_street: street,
      e_to_house: house,
      e_to_locale: locale,
      e_to_postal_code: postal_code,
      e_to_city: city,
      e_to_phone: phone
  }
};

function parseItems(lines) {
  count = 0;
  description = []
  for(item in items){
    match = items[item].match(/(\d.\d{2}g) x (\d+)/)
    count += parseInt(match[2])
    description.push(match[1] + ' x ' + parseInt(match[2]))
  }
  description = description.join(', ');

  return {
    e_weight: count,
    e_description: description,
    e_size1: 30,
    e_size2: 20,
    e_size3: 10,
    e_unstandard: 3
  }
}

function sendRequest(name, value) {
  chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    var tab = tabs[0];
    chrome.tabs.sendRequest(tab.id, {name: name, value: value});
  });
}

document.getElementsByTagName('button')[0].addEventListener('click', function(){
  textarea = document.getElementById('address');
  data = parseVal(textarea.value);
  for(var name in data){
    if (name !== undefined) {
      sendRequest(name, data[name]);
    };
  };
});


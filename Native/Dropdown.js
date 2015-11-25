Elm.Native.Dropdown = Elm.Native.Dropdown || {};
Elm.Native.Dropdown.make = function(elm)
{
  elm.Native = elm.Native || {};
  elm.Native.Dropdown = elm.Native || {};
  if (elm.Native.Dropdown.values)
  {
    return elm.Native.Dropdown.values;
  }

  function setFocus ()
  {
  }

  return elm.Native.Dropdown.values = Elm.Native.Dropdown.values = {
    setFocus: setFocus
  };
}

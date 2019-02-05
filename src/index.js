import { Elm } from './Main.elm';

if (process.env.NODE_ENV === 'development') {
  console.log(
    '%c Your Elm App is running in development mode!',
    'color: maroon; font-size: 16px; font-weight: bold;'
  );
  Elm.Main.init({
    node: document.getElementById('yoruichi'),
    flags: {
      theme: {
        baseBackground: 'ffffff',
        baseBackgroundHover: 'd9d9d9',
        baseColour: '000000',
        colour: '850512',
        contrast: '7e7e86',
        anchorColour: 'ce414a',
        anchorColourHover: 'e1e3ef',
        primaryBackground: '850512',
        primaryBackgroundHover: 'cf081c',
        primaryColour: 'e1e3ef'
      }
    }
  });
}

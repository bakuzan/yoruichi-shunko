import { Elm } from './Main.elm';

const themeOne = {
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
};

const themeTwo = {
  baseBackground: '420309',
  baseBackgroundHover: '8b0613',
  baseColour: 'ffffff',
  colour: 'ce414a',
  contrast: 'e1e3ef',
  anchorColour: '7e7e86',
  anchorColourHover: '850512',
  primaryBackground: '850512',
  primaryBackgroundHover: 'cf081c',
  primaryColour: 'e1e3ef'
};

if (process.env.NODE_ENV === 'development') {
  console.log(
    '%c Your Elm App is running in development mode!',
    'color: palevioletred; font-size: 16px; font-weight: bold;'
  );
  const app = Elm.Main.init({
    node: document.getElementById('yoruichi'),
    flags: {
      theme: themeOne
    }
  });

  // THEME TEST
  // let timer = null;
  // let newTheme = themeOne;
  // updateBody(newTheme);

  // clearInterval(timer);
  // timer = setInterval(() => {
  //   newTheme =
  //     themeOne.baseBackground === newTheme.baseBackground ? themeTwo : themeOne;

  //   app.ports.theme.send(newTheme);
  //   updateBody(newTheme);
  // }, 5000);
} else {
  console.log(
    `%c Your Elm App is only designed to run in development mode!`,
    'color: brickred; font-size: 16px; font-weight: bold;'
  );
}

function updateBody(theme) {
  const style = document.getElementById('dev-style');

  style.innerHTML = `
    body {
      background-color: #${theme.baseBackground};
      color: #${theme.baseColour};
    }
  `;
}

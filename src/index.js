import { Elm } from "./Main.elm";

if (process.env.NODE_ENV === "development") {
  console.log(
    "%c Your Elm App is running in development mode!",
    "color: maroon; font-size: 16px; font-weight: bold;"
  );
  Elm.Main.init({
    node: document.getElementById("yoruichi")
  });
}

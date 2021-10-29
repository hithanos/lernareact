import React from "react";
import { Appexported } from "lernareact/src/index";
type AppProps = Record<string, unknown>;

const App: React.FC<AppProps> = (props) => (
  <div>
    Hello Guys
    <Appexported />
  </div>
);

export default App;

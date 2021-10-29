AUTHOR='Yashwanth Putta'
AUTHOR_EMAIL='yashwanth.putta@qapitacorp.com'
PROJECT_NAME='QapMap PWA'

cat << EOF > package.json
{
  "name": "${PROJECT_NAME}",
  "version": "0.1.0",
  "main": "index.js",
  "description": "TODO",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build:tsc": "tsc -p tsconfig.json && tsc -p tsconfig-cjs.json",
    "build": "rimraf ./dist && webpack",
    "start:dev": "webpack-cli serve --mode=development --env development --open --hot",
    "lint": "eslint './src/**/*.{ts,tsx}'",
    "lint:fix": "eslint './src/**/*.{ts,tsx}' --fix"
  },
  "keywords": [],
  "author": "${AUTHOR} <${AUTHOR_EMAIL}>",
  "license": "Copyright Qapita Fintech Pte. Ltd."
}
EOF

cat << EOF > .gitignore
# Yarn
.yarn/*
.yarn/cache
!.yarn/releases
!.yarn/plugins
!.yarn/sdks
!.yarn/versions

**/dist/*
**/lib/*

**/node_modules/*
**/*.tar.gz
**/*.zip

.idea/
.vscode/
node_modules/
build
.DS_Store
*.tgz
my-app*
template/src/__tests__/__snapshots__/
lerna-debug.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
/.changelog
.npm/
yarn.lock
EOF

cat << EOF > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2015",
    "module": "ES2020",
    "outDir": "./dist/esm",
    "types": [],
    "declaration": true,
    "jsx": "react",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "lib": ["es2018", "dom"]
  },
  "include": ["src/**/*.ts", "src/**/*.tsx"]
}
EOF

cat << EOF > tsconfig-cjs.json
{
    "extends": "./tsconfig.json",
    "compilerOptions": {
        "module": "commonjs",
        "outDir": "./dist/cjs"
    }
}
EOF

npm install -S \
    react react-dom react-router react-router-dom \
    antd \
    dotenv

npm install -D \
    @types/react @types/react-dom @types/react-router @types/react-router-dom \
    typescript \
    prettier \
    eslint \
    eslint-config-prettier eslint-plugin-prettier \
    eslint-plugin-import @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    eslint-plugin-react eslint-plugin-react-hooks \
    webpack webpack-cli webpack-dev-server \
    html-webpack-plugin fork-ts-checker-webpack-plugin \
    ts-loader css-loader file-loader url-loader sass-loader style-loader \
    node-sass \
    rimraf cross-env \
    jest

cat << EOF > .eslintrc.json
{
  "parser": "@typescript-eslint/parser",
  "plugins": [
    "@typescript-eslint",
    "react",
    "react-hooks",
    "eslint-plugin-import",
    "prettier"
  ],
  "env": {
    "browser": true
  },
  "extends": [
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:prettier/recommended"
  ],
  "parserOptions": {
    "project": ["tsconfig.json"],
    "ecmaVersion": 2020,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/no-unused-vars": "off",
    "react/jsx-filename-extension": [
      "warn",
      {
        "extensions": [".jsx", ".tsx"]
      }
    ],
    "react/prop-types": "off",
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn"
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
EOF

cat << EOF > .eslintignore
webpack.config.js
webpack.config.json
EOF

cat << EOF > webpack.config.js
const path = require("path");
const webpack = require("webpack");

const HtmlWebpackPlugin = require("html-webpack-plugin");
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");

const webpackConfig = (env) => ({
  entry: "./src/index.tsx",
  mode: "development",
  ...(env.production || !env.development ? {} : { devtool: "eval-source-map" }),
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".jsx", ".json", ".sass", ".css", ".less"],
    //TODO waiting on https://github.com/dividab/tsconfig-paths-webpack-plugin/issues/61
    //@ts-ignore
    //plugins: [new TsconfigPathsPlugin()]
  },
  output: {
    path: path.join(__dirname, "/dist"),
    filename: "build.js",
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
        options: {
          transpileOnly: true,
        },
        exclude: /dist|node_modules/,
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./public/index.html",
    }),
    new webpack.DefinePlugin({
      "process.env.PRODUCTION": env.production || !env.development,
      "process.env.NAME": JSON.stringify(require("./package.json").name),
      "process.env.VERSION": JSON.stringify(require("./package.json").version),
    }),
    new ForkTsCheckerWebpackPlugin({
      eslint: {
        files: "./src/**/*.{ts,tsx,js,jsx}", // required - same as command "eslint ./src/**/*.{ts,tsx,js,jsx} --ext .ts,.tsx,.js,.jsx"
      },
    }),
  ],
});

module.exports = webpackConfig;
EOF

mkdir -p public src

cat << EOF > public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Qapita</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF

cat << EOF > src/app.tsx
import React from "react";

type AppProps = Record<string, unknown>;

const App: React.FC<AppProps> = (props) => <div>Hello World!</div>;

export default App;
EOF

cat << EOF > src/index.tsx
import React from "react";
import ReactDOM from "react-dom";
import App from "./app";

ReactDOM.render(<App />, document.getElementById("root"));
EOF
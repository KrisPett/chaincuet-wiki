#### Change Scroll Bar

```
"*::-webkit-scrollbar-thumb": {
      backgroundColor: `grey`,
      borderRadius: "20px",
      border: "6px solid transparent",
      backgroundClip: "content-box",
    },
    "::-webkit-scrollbar-thumb:hover": {
      backgroundColor: `grey`,
    },
    "*::-webkit-scrollbar": {width: '20px'},
```

## Tailwind style

#### Prettier

``` 
yarn add prettier-plugin-tailwindcss --dev
yarn add prettier --dev

npx prettier --write index.tsx
npx prettier --write .
```

#### Style Libraries

``` 
daisyui
https://heroicons.com/
```

#### Tailwind Config Example

```
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
    "./layouts/**/*.{js,ts,jsx,tsx}",
    "./lib/**/*.{js,ts,jsx,tsx}",
  ],
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("daisyui"),
  ],
  daisyui: {
    styled: true,
    themes: ["light", "dark"],
    base: false,
    utils: true,
    logs: true,
    rtl: false,
    prefix: "",
    darkTheme: "dark",
  },
  darkMode: "class",
  theme: {
    screens: {
      xxs: "0px",
      xs: "375px",
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1280px",
      "2xl": "1536px",
    },
    fontFamily: {
      sans: ["Helvetica", "Arial", "sans-serif"],
      serif: ["ui-serif", "Georgia"],
      mono: ["ui-monospace", "SFMono-Regular"],
      display: ["Oswald"],
      body: ['"Open Sans"'],
    },
    extend: {
      spacing: {
        128: "32rem",
        144: "36rem",
      },
      borderRadius: {
        "4xl": "2rem",
      },
    },
    minHeight: {
      0: "0",
      "1/4": "25%",
      "1/2": "50%",
      "3/4": "75%",
      full: "100%",
      144: "500px",
    },
  },
};
```


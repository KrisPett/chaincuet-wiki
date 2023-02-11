## CSS

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

#### Tailwind Utilities Size

##### Margin, Padding

```
0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9 10, 11, 12, 14, 16, 20, 24, 28, 
32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96
```

##### Width Height ( w-11/12, w-5/6 h-11/12, h-5/6 )

```
0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9 10, 11, 12, 14, 16, 20, 24, 28, 
32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96
```

##### Max Height

```
0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9 10, 11, 12, 14, 16, 20, 24, 28, 
32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96
```

##### Min Height

```
min-h-0, min-h-full, min-h-screen, min-h-min, min-h-max, min-h-fit
```

## MUI

#### Transition Styling

```
import useTheme from "@mui/material/styles/useTheme";
const theme = useTheme();
sx={{
  cursor: "pointer",
  transition: theme.transitions.create(["background-color", "transform"], 
    {duration: theme.transitions.duration.standard}),
  "&:hover": { transform: "scale(1.1)" }
}}
```
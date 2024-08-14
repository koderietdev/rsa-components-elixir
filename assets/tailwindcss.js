const white = "#FFFFFF"

const brand = {
  50: "#EAECFB",
  100: "#CDD1F4",
  200: "#ABB2ED",
  300: "#7F8BE6",
  400: "#5162E1",
  500: "#2539DA",
  600: "#1A2BAD",
  700: "#132081",
  800: "#0D1554",
  900: "#0A0F38",
}
const neutral = {
  25: "#F8F9FD",
  50: "#EEEFF3",
  100: "#DADBDE",
  200: "#C7C7CB",
  300: "#A7A7AB",
  400: "#848488",
  500: "#69696D",
  600: "#57585C",
  700: "#454549",
  800: "#35363A",
  900: "#26262A",
  950: "#15161A",
}

module.exports = {
  colors: {
    brand: {
      50: brand[50],
      100: brand[100],
      200: brand[200],
      300: brand[300],
      400: brand[400],
      500: brand[500],
      600: brand[600],
      700: brand[700],
      800: brand[800],
      900: brand[900],
    },
    neutral: {
      25: neutral[25],
      50: neutral[50],
      100: neutral[100],
      200: neutral[200],
      300: neutral[300],
      400: neutral[400],
      500: neutral[500],
      600: neutral[600],
      700: neutral[700],
      800: neutral[800],
      900: neutral[900],
      950: neutral[950],
    },
    fg: {
      DEFAULT: neutral[900],
      strong: neutral[950],
      muted: neutral[700],
      suble: neutral[500],
      weak: neutral[400],
      link: {
        DEFAULT: brand[500],
        hover: brand[700],
        visited: neutral[700]
      },
      onInverted: {
        DEFAULT: white,
        muted: neutral[100],
        subtle: neutral[300],
        weak: neutral[500]
      },
      brand: {
        DEFAULT: brand[600],
        muted: brand[500],
        subtle: brand[400],
      }
    },
    bg: {
      DEFAULT: neutral[25],
      muted: neutral[100],
      subtle: neutral[50],
      white: white,
      brand: {
        DEFAULT: brand[600],
        hover: brand[700],
        muted: brand[100],
        subtle: brand[50],
      },
      inverted: {
        DEFAULT: neutral[950],
        muted: neutral[900],
        subtle: neutral[700],
      }
    },
    border: {
      DEFAULT: neutral[100],
      hover: neutral[500],
      muted: neutral[50],
      subtle: neutral[25],
      strong: neutral[700],
      white: white,
      input: {
        DEFAULT: neutral[200],
        hover: neutral[400],
        pressed: brand[400],
      },
      brand: {
        DEFAULT: brand[500],
        hover: brand[700],
        muted: brand[200],
        subtle: brand[100]
      }
    },
  },
}

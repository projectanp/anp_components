import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import typescript from "@rollup/plugin-typescript";
import { dts } from "rollup-plugin-dts";

// Correct way to import package.json in an ES Module context
import packageJson from "./package.json" assert { type: "json" };

export default [
  // Main JavaScript Bundle Configuration
  {
    input: "src/index.ts",
    output: [
      {
        file: packageJson.main, // e.g., dist/index.cjs (if main points there)
        format: "cjs",
        sourcemap: true,
      },
      {
        file: packageJson.module, // e.g., dist/index.esm (if module points there)
        format: "esm",
        sourcemap: true,
      },
    ],
    plugins: [
      resolve(),
      commonjs(),
      typescript({
        tsconfig: "./tsconfig.json",
        // This plugin handles JS compilation, so 'emitDeclarationOnly' in tsconfig
        // is fine if you're using rollup-plugin-dts for d.ts bundling.
      }),
    ],
    // Ensure you list external dependencies if your library has them
    external: [...Object.keys(packageJson.dependencies || {}), ...Object.keys(packageJson.peerDependencies || {})],
  },

  // Type Declaration Bundle Configuration
  {
    // *** IMPORTANT: Adjust this path based on your tsconfig.json's declarationDir ***
    // If your tsconfig.json has "declarationDir": "dist/types", then this is likely correct:
    input: "dist/types/index.d.ts", // Or whatever your main entry's d.ts file is named and where it's outputted
    output: [{ file: packageJson.types, format: "esm" }], // Use packageJson.types for the output d.ts file
    plugins: [dts()], // Call dts as a function
  },
];
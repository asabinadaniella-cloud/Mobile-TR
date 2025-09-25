import js from '@eslint/js';
import pluginReact from 'eslint-plugin-react';
import pluginTs from '@typescript-eslint/eslint-plugin';
import parserTs from '@typescript-eslint/parser';
import configPrettier from 'eslint-config-prettier';

export default [
  {
    ignores: ['node_modules', 'dist', 'build']
  },
  js.configs.recommended,
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: parserTs,
      parserOptions: {
        project: './tsconfig.json',
        tsconfigRootDir: import.meta.dirname,
        ecmaFeatures: {
          jsx: true
        }
      }
    },
    plugins: {
      '@typescript-eslint': pluginTs,
      react: pluginReact
    },
    settings: {
      react: {
        version: 'detect'
      }
    },
    rules: {
      ...pluginReact.configs.recommended.rules,
      ...pluginTs.configs.recommended.rules,
      'react/react-in-jsx-scope': 'off'
    }
  },
  configPrettier
];

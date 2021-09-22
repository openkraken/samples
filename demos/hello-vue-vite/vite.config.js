import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

export default defineConfig(({ mode }) => ({
  plugins: [vue()],
  build: {
    minify: mode === 'production',
    rollupOptions: {
      input: 'src/main.js',
      output: {
        entryFileNames: `[name].js`,
        manualChunks: {}
      }
    }
  }
}))

# CMSC398W: Practical Tools for Efficient Development

Course site for CMSC398W, built with [Astro](https://astro.build) and [Starlight](https://starlight.astro.build). Deployed at **https://cmsc398w.github.io/course_docs/**.

## Local Development

**Prerequisites:**
- Node.js 22+
- Emacs (for building slides from `.org` sources)
- TeX Live with XeLaTeX (`texlive-xetex`, `texlive-latex-extra`, `texlive-latex-recommended`, `texlive-fonts-recommended`, `texlive-extra-utils`)
- [BeamerReveal](https://metacpan.org/dist/BeamerReveal) Perl module (`cpanm BeamerReveal`)
- `poppler-utils` and `ffmpeg` (used by BeamerReveal for PDF/video processing)

**Install Node dependencies:**
```bash
npm install
```

**Build slides** (generates HTML/PDF from `.org` sources):
```bash
bash scripts/build-slides.sh
```

**Run dev server:**
```bash
npm run dev
```

**Build for production:**
```bash
npm run build
npm run preview
```

## Project Structure

```
slides/          # Org-mode Beamer slide sources + images
scripts/         # build-slides.sh, export-slides.el, beamer-reveal.sty
src/
  content/docs/  # Starlight markdown/MDX pages
  components/    # Astro components (e.g. SlideEmbed)
public/          # Static assets; slides are built into public/slides/
```

## Deployment

Pushes to `main` trigger the GitHub Actions workflow (`.github/workflows/deploy.yml`), which:
1. Installs Emacs, TeX Live, BeamerReveal, and supporting tools
2. Compiles org-mode slides to PDF and reveal.js HTML via `build-slides.sh`
3. Builds the Astro site with `npm run build`
4. Deploys to GitHub Pages

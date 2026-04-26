# Yogashala Particular · Amposta

Web premium de clases particulares de yoga terapéutico. Una sola página HTML
autocontenida (CSS y JS inline), pensada para abrir directamente o servirla
desde GitHub Pages / Netlify.

## Cómo abrirla en local

Doble click en `web-yoga-amposta.html` o:

```bash
open web-yoga-amposta.html        # macOS
xdg-open web-yoga-amposta.html    # Linux
start web-yoga-amposta.html       # Windows
```

> Si abres `file://...` directamente, el hero canvas funciona porque el
> `fetch` lo eliminamos. Si quieres servirla con un mini-servidor:
>
> ```bash
> python3 -m http.server 8080
> # http://localhost:8080/web-yoga-amposta.html
> ```

## Estructura

```
web-yoga-amposta/
├── web-yoga-amposta.html   ← todo el sitio en un único archivo
├── assets/
│   ├── logo.png            ← logo
│   ├── hero.mov            ← vídeo original (gitignored)
│   ├── frames/             ← 160 frames JPG extraídos del vídeo
│   ├── personal-2015.jpg   ← fotos por año (timeline)
│   ├── personal-2018.jpg
│   ├── personal-2019.jpg
│   ├── personal-2020.jpg
│   ├── personal-2023.jpg
│   └── foto-web-1..5.jpg   ← galería "Ella"
├── extract_frames.swift    ← script para regenerar frames si cambia el vídeo
├── README.md
└── .gitignore
```

## Hero scroll-video (técnica Apple)

El hero NO usa `<video>`. Usa `<canvas>` y dibuja el frame correspondiente al
progreso de scroll, exactamente como hace Apple en sus landing pages
(AirPods Pro, iPhone, etc.).

- 160 frames JPG (~57MB total) extraídos del `.mov` con AVFoundation a 1500px.
- Carga progresiva: primero pares, luego impares (ves todo el recorrido cuanto antes).
- El último 18 % del scroll **congela el último frame** para que el plano final
  (la profesora) quede claro y se pueda leer el título encima.
- Móvil: cae a estado estático para no bombardear ancho de banda.

### Si cambias el vídeo

Sustituye `assets/hero.mov` y regenera los frames:

```bash
swift extract_frames.swift assets/hero.mov assets/frames 160
```

Variables del script: ancho máx 1500px, calidad JPG 0.72.

## CTA → WhatsApp

Los botones "Reservar llamada" / "Reserva una llamada por WhatsApp" llevan a:

```
https://wa.me/34654639006?text=...
```

Con un mensaje predeterminado. Cambia el número o el texto en el HTML
(buscar `wa.me/34654639006`).

## TODOs pendientes

- [ ] Logo optimizado para fondo oscuro (ahora se aplica `filter: invert` al PNG).
- [ ] Fotos para los años antiguos sin imagen real: 1996, 2001, 2007, 2010, 2026.
- [ ] Copy real en todas las secciones (todo lo que está en gris cursiva).
- [ ] Email real de contacto (provisional: `yogashala@particular.com`).
- [ ] Frase de marca real del hero.
- [ ] Confirmar el número de WhatsApp si cambia.
- [ ] Dominio + despliegue.

## Decisiones técnicas

- **Sin frameworks.** Un único HTML. Cero dependencias salvo Google Fonts.
- **Hero canvas** porque `<video>` con `currentTime` no es fiable en todos los
  navegadores y la imagen sequence es la solución que usa Apple.
- **Timeline horizontal con scroll-hijack vanilla** (sin GSAP). Sección
  `600vh`, sticky pin, `translate3d` proporcional al scroll.
- **Header de la timeline se desvanece** entre los hitos para que el título
  no tape las fotos cuando estás navegando hitos.
- **Móvil**: timeline a scroll horizontal nativo con snap; hero a estado
  estático; gallery a grid de 2 columnas.
- **Tipografías**: Cormorant Garamond (titulares) + Inter (cuerpo).
- **Paleta**: negro `#0A0A0A`, crema `#F5F0E8`, oro mate `#C9A961`, salvia `#8A9A7B`.

## Despliegue

Cualquiera de estas opciones:

1. **GitHub Pages** (recomendado): tras subir el repo, Settings → Pages → Source: `main` / `/ (root)`. URL pública en minutos.
2. **Netlify Drop**: arrastra la carpeta entera a https://app.netlify.com/drop.
3. **Vercel**: `vercel deploy` desde la carpeta (requiere CLI de Vercel).

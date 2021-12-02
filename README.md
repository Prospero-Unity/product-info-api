# Prospero-Unity Products API

Lightweight, scalable microservice serving a growing ecommerce front-end

## Contents

- [Tech Stack](#tech-stack)
- [System Architecture](#system-architecture)

---

### Tech Stack

![node](https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg)

- Node.js is an event-driven runtime environment used for scaling our api.

![express](https://www.vectorlogo.zone/logos/expressjs/expressjs-ar21.svg)

- Express was chosen because it offers simplified HTTP routing methods

![postgres](https://www.vectorlogo.zone/logos/postgresql/postgresql-ar21.svg)

- PostreSQL is used here as a robust and stable open source database

![nginx](https://www.vectorlogo.zone/logos/nginx/nginx-ar21.svg)

- NGINX enables load balancing HTTP traffic between between many routers

---

### System Architecture
This design is most optimal between 1 - 6000 RPS. This design provided a lower server cost by utilizing horizontal scaling with a load balancer to distribute our api calls across the servers. This design also makes use of a memory cache to reduce the datbase load. 

![](https://i.imgur.com/mGDWrVG.png)


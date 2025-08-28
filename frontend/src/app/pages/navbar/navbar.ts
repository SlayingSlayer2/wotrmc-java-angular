import { Component } from '@angular/core';
import {MenuItem, PrimeTemplate} from 'primeng/api';
import {Menubar} from 'primeng/menubar';
import {ButtonDirective} from 'primeng/button';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.html',
  standalone: true,
  imports: [
    Menubar,
    PrimeTemplate,
    ButtonDirective
  ],
})
export class Navbar {
  items: MenuItem[] = [];

  ngOnInit() {
    this.items = [
      {
        label: 'Home',
        icon: 'pi pi-home',
        items: [
          { label: 'Landing', routerLink: ['/'] },
          { label: 'Updates', routerLink: ['/updates'] },
          { label: 'How to Play', routerLink: ['/how-to-play'] },
        ],
      },
      {
        label: 'War Breakdown',
        icon: 'pi pi-sitemap',
        items: [
          { label: 'Factions', routerLink: ['/factions'] },
          { label: 'Realms', routerLink: ['/realms'] },
          { label: 'Waypoints', routerLink: ['/waypoints'] },
        ],
      },
      {
        label: 'Account',
        icon: 'pi pi-user',
        items: [
          { label: 'Profile', routerLink: ['/account/profile'] },
          { label: 'Logout', routerLink: ['/logout'] },
        ],
      },
      {
        label: 'Socials',
        icon: 'pi pi-share-alt',
        items: [
          { label: 'Discord', url: 'https://discord.gg/yourserver', target: '_blank' },
          { label: 'GitHub', url: 'https://github.com/yourrepo', target: '_blank' },
          { label: 'Twitch', url: 'https://twitch.tv/theslayingslayer', target: '_blank' },
        ],
      }
    ];
  }
}

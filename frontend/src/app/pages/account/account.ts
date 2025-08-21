import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-account',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './account.html',
  styleUrls: ['./account.scss']
})
export class Account {
  form = {
    email: '',
    password: '',
    race: ''
  };

  races = [
    { label: 'Man', value: 'MAN' },
    { label: 'Elf', value: 'ELF' },
    { label: 'Dwarf', value: 'DWARF' },
    { label: 'Orc', value: 'ORC' }
  ];

  signup() {
    console.log('Signup form submitted:', this.form);
    // TODO: call backend /auth/signup
  }
}

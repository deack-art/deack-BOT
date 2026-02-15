const { Client, GatewayIntentBits, PermissionsBitField } = require('discord.js');

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.GuildMembers
  ]
});

// PODERES
const poderez = {
  "Mercenario": "💴 Mercenário",
  "Comerciante": "💰 Comerciante"
};

const usuarios = {};
const saldo = {};

client.once('ready', () => {
  console.log(`Bot online como ${client.user.tag}`);
});

client.on('messageCreate', async (message) => {
  if (message.author.bot) return;

  const args = message.content.split(" ");
  const comando = args[0];

  // DAR PODERES
  if (comando === "!darpoderez") {
    if (!message.member.permissions.has(PermissionsBitField.Flags.Administrator))
      return message.reply("Você não tem permissão, peça para um adm.");

    const membro = message.mentions.members.first();
    const nomePoderez = args[2];

    if (!membro || !poderes[nomepoderes])
      return message.reply("Use: !darpoderes @usuario Mercenario ou Comerciante");

    if (!usuarios[membro.id]) usuarios[membro.id] = [];
    if (!saldo[membro.id]) saldo[membro.id] = 0;

    usuarios[membro.id].push(nomePoderes);

    let role = message.guild.roles.cache.find(r => r.name === poderes[nomepoderes]);

    if (!role) {
      role = await message.guild.roles.create({
        name: poderes[nomePoderes],
        reason: "Cargo de poderes"
      });
    }

    await membro.roles.add(role);

    message.channel.send(`🔥 ${membro.user.username} recebeu o Poderes ${nomePoderes}`);
  }

  // COMANDO DINHEIRO (MERCENARIO)
  if (comando === "!dinheiro") {
    if (!usuarios[message.author.id]?.includes("Mercenario"))
      return message.reply("Você não possui o Poder Mercenário.");

    if (!saldo[message.author.id]) saldo[message.author.id] = 0;

    const ganho = Math.floor(Math.random() * 50) + 50; // ganha entre 50 e 100
    saldo[message.author.id] += ganho;

    message.reply(`💴 Você ganhou ${ganho} Kings!\n💰 Saldo atual: ${saldo[message.author.id]} Kings`);
  }

  // VER SALDO
  if (comando === "!saldo") {
    if (!saldo[message.author.id]) saldo[message.author.id] = 0;
    message.reply(`💰 Seu saldo: ${saldo[message.author.id]} Kings`);
  }

  // TROCAR (COMERCIANTE)
  if (comando === "!trocar") {
    if (!usuarios[message.author.id]?.includes("Comerciante"))
      return message.reply("Você não possui o Poder Comerciante.");

    const membro = message.mentions.members.first();
    const valor = parseInt(args[2]);

    if (!membro || isNaN(valor))
      return message.reply("Use: !trocar @usuario quantidade");

    if (!saldo[message.author.id] || saldo[message.author.id] < valor)
      return message.reply("Você não tem Kings suficientes.");

    if (!saldo[membro.id]) saldo[membro.id] = 0;

    saldo[message.author.id] -= valor;
    saldo[membro.id] += valor;

    message.channel.send(`💰 ${message.author.username} transferiu ${valor} Kings para ${membro.user.username}`);
  }
});

client.login(process.env.TOKEN);

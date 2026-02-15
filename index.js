const { Client, GatewayIntentBits } = require('discord.js');

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.GuildMembers
  ]
});

client.once('ready', () => {
  console.log(`Bot online como ${client.user.tag}`);
});

client.on('messageCreate', message => {
  if (message.author.bot) return;

  if (message.content === '!YT') {
    message.reply('https://youtube.com/channel/UCQMJwc3aJktnUWeA5ff8FJw?si=V4YvOALFyx5Q1hHv 🖤');
  }
});

client.login(process.env.TOKEN);

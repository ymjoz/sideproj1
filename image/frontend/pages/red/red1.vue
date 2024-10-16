<template>
  <div>
    <h3>
      {{ testRed }}
    </h3>
    <ul>
      <li>
        <NuxtLink to="/">Home</NuxtLink>
      </li>
      <li></li>
    </ul>
    <div>
      <p>Dynamic Component...</p>
      <button @click="currentTab = 'ComponentOne'">What is JS?</button>
      <button @click="currentTab = 'ComponentTwo'">What is Python?</button>
      <button @click="currentTab = 'ComponentThree'">What is CSS?</button>
    </div>
    <div>
      <component :is="tabs[currentTab]" />
    </div>
  </div>
</template>

<script setup>
  import { ref } from 'vue';
  import ComponentOne from '~/components/ComponentOne.vue';
  import ComponentTwo from '~/components/ComponentTwo.vue';
  import ComponentThree from '~/components/ComponentThree.vue';

  const testRed = ref('testRed');

  const currentTab = ref('ComponentThree');
  const tabs = {
    ComponentOne,
    ComponentTwo,
    ComponentThree
  }



</script>

<style lang="scss" scoped></style>
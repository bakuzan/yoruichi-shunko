const gql = require('graphql-tag');

const { mapArrToGraphqlString } = require('../utils');
const { RepeatPattern, CalendarMode } = require('../constants/enums');

const Enums = [
  gql`
  enum RepeatPattern {
    ${mapArrToGraphqlString(RepeatPattern)}
  }`,
  gql`
  enum CalendarMode {
    ${mapArrToGraphqlString(CalendarMode)}
  }`
];

const Query = gql`
  type Query {
    todoTemplates: [TodoTemplate]
    todoInstances: [TodoInstance]

    calendarView(mode: CalendarMode!, date: String!): [TodoInstance]
  }
`;

const Mutation = gql`
  type Mutation {
    todoTemplateRemove(id: Int!): DeleteReponse
    todoInstanceRemove(id: Int!): DeleteReponse
  }
`;

const Todo = gql`
  type TodoTemplate {
    id: Int!
    name: String
    date: Date
    repeatPattern: RepeatPattern
    repeatFor: Int
    repeatWeekDefinition: Int
    instances: [TodoInstance]
  }
  input TodoTemplateInput {
    id: Int
    name: String
    date: Date
    repeatPattern: RepeatPattern
    repeatFor: Int
    repeatWeekDefinition: Int
  }

  type TodoInstance {
    id: Int
    name: String
    date: Date
    isRepeated: Boolean
    todoTemplateId: Int
    template: TodoTemplate
  }
`;

const CustomTypes = gql`
  scalar Date

  type DeleteReponse {
    success: Boolean
    errorMessages: [String]
  }
`;

module.exports = [...Enums, Query, Mutation, Todo, CustomTypes];
